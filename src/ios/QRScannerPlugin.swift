import Foundation	
import AVFoundation

@objc(QRScannerPlugin) class QRScannerPlugin : CDVPlugin,AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer!
    var cameraView: CameraView!
    var command: CDVInvokedUrlCommand?
    var metaOutput: AVCaptureMetadataOutput?
    
    enum QRScannerError: String {
        case unexpected_error = "unexpected_error",
        camera_access_denied = "camera_access_denied",
        camera_access_restricted = "camera_access_restricted",
        camera_unavailable = "camera_unavailable"
    }
    
    class CameraView: UIView {
        var videoPreviewLayer:AVCaptureVideoPreviewLayer?
        func interfaceOrientationToVideoOrientation(_ orientation : UIInterfaceOrientation) -> AVCaptureVideoOrientation {
            switch (orientation) {
            case UIInterfaceOrientation.portrait:
                return AVCaptureVideoOrientation.portrait;
            case UIInterfaceOrientation.portraitUpsideDown:
                return AVCaptureVideoOrientation.portraitUpsideDown;
            case UIInterfaceOrientation.landscapeLeft:
                return AVCaptureVideoOrientation.landscapeLeft;
            case UIInterfaceOrientation.landscapeRight:
                return AVCaptureVideoOrientation.landscapeRight;
            default:
                return AVCaptureVideoOrientation.portraitUpsideDown;
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews();
            if let sublayers = self.layer.sublayers {
                for layer in sublayers {
                    layer.frame = self.bounds;
                }
            }
            self.videoPreviewLayer?.connection?.videoOrientation = interfaceOrientationToVideoOrientation(UIApplication.shared.statusBarOrientation);
        }
        
        func addPreviewLayer(_ previewLayer:AVCaptureVideoPreviewLayer?) {
            previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer!.frame = self.bounds
            self.layer.addSublayer(previewLayer!)
            self.videoPreviewLayer = previewLayer;
        }
        
        func removePreviewLayer() {
            if self.videoPreviewLayer != nil {
                self.videoPreviewLayer!.removeFromSuperlayer()
                self.videoPreviewLayer = nil
            }
        }
    }
    
    private func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        if #available(iOS 8.0, *) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                if (background != nil) {
                    background!()
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay * Double(NSEC_PER_SEC)) {
                    if(completion != nil){
                        completion!()
                    }
                }
            }
        } else {
            if(background != nil){
                background!()
            }
            if(completion != nil){
                completion!()
            }
        }
    }
    
    private func prepScanner(_ command: CDVInvokedUrlCommand) -> Bool {
        var pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)
        if self.captureSession == nil || self.captureSession?.isRunning == false {
            self.captureSession = AVCaptureSession()
            if let captureSession = self.captureSession {
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                if (status == AVAuthorizationStatus.restricted) {
                    pluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: QRScannerError.camera_access_restricted.rawValue)
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                    return false
                } else if status == AVAuthorizationStatus.denied {
                    pluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR, messageAs: QRScannerError.camera_access_denied.rawValue)
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                    return false
                }
                self.cameraView.backgroundColor = UIColor.clear
                self.webView!.superview!.insertSubview(self.cameraView, belowSubview: self.webView!)
                guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                    return false
                }
                let videoInput: AVCaptureDeviceInput
                do {
                    videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                } catch let error {
                    print(error)
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                    return false
                }
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                } else {
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                    return false
                }
                self.metaOutput = AVCaptureMetadataOutput()
                if captureSession.canAddOutput(self.metaOutput!) {
                    captureSession.addOutput(self.metaOutput!)
                    self.metaOutput!.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    self.metaOutput!.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                    self.captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    self.cameraView.addPreviewLayer(captureVideoPreviewLayer)
                    captureSession.startRunning();
                    return true
                } else {
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                    return false
                }
            }
        }
        return true
    }
    
    override func pluginInitialize() {
        super.pluginInitialize()
        self.cameraView = CameraView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.cameraView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 { return }
        if let first = metadataObjects.first {
            guard let readableObject = first as? AVMetadataMachineReadableCodeObject else { return }
            if readableObject.type == AVMetadataObject.ObjectType.qr {
                guard let stringyfiedValue = readableObject.stringValue else { return }
                print("QRCode - \(stringyfiedValue)")
                if let command = self.command {
                    let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: stringyfiedValue)
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                    self.command = nil
                }
            }
        }
    }
    
    private func stopScanning() {
        if let captureSession = self.captureSession {
            captureSession.stopRunning()
            self.cameraView.removePreviewLayer()
            self.captureVideoPreviewLayer = nil
            self.captureSession = nil
            self.captureVideoPreviewLayer = nil
            self.metaOutput = nil
        }
    }
    
    private func startScanning(_ command: CDVInvokedUrlCommand) {
        self.backgroundThread(delay: 0, completion: {
            if(self.prepScanner(command)) {
                self.makeOpaque()
            }
        })
    }
    
    func makeOpaque() {
        self.webView?.isOpaque = false
        self.webView?.backgroundColor = UIColor.clear
    }
    
    @objc(qrScanner:)
    func qrScanner (_ command: CDVInvokedUrlCommand) {
        let methodName = command.arguments[0] as! String
        if methodName == "startScanner" {
            self.startScanner(command)
        } else if methodName == "stopScanner" {
            self.stopScanner(command)
        }
    }
    
    @objc(startScanner:)
    func startScanner(_ command: CDVInvokedUrlCommand) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        self.command = command
        if (status == AVAuthorizationStatus.notDetermined) {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) -> Void in
                self.startScanning(command)
            })
        } else {
            self.startScanning(command)
        }
    }
    
    @objc(stopScanner:)
    func stopScanner(_ command: CDVInvokedUrlCommand) {
        let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK)
        self.makeOpaque()
        backgroundThread(delay: 0, background: {
            self.stopScanning()
        }, completion: {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        })
    }
}

