import Foundation	
	import AVFoundation
	
	@author DineshKokare
	
	@objc(QRScannerPlugin) class QRScannerPlugin : CDVPlugin,AVCaptureMetadataOutputObjectsDelegate {
	
	class CameraView: UIView {
	var videoPreviewLayer:AVCaptureVideoPreviewLayer?
	
	//Interface Method.:
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
	
	var cameraView: CameraView!
	var captureSession:AVCaptureSession?
	var captureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
	var metaOutput: AVCaptureMetadataOutput?
	
	var currentCamera: Int = 0;
	var frontCamera: AVCaptureDevice?
	var backCamera: AVCaptureDevice?
	
	var scanning: Bool = false
	var paused: Bool = false
	var nextScanningCommand: CDVInvokedUrlCommand?
	
	enum QRScannerError: Int32 {
	case unexpected_error = 0,
	camera_access_denied = 1,
	camera_access_restricted = 2,
	back_camera_unavailable = 3,
	front_camera_unavailable = 4,
	camera_unavailable = 5,
	scan_canceled = 6,
	light_unavailable = 7,
	open_settings_unavailable = 8
	}
	
	enum CaptureError: Error {
	case backCameraUnavailable
	case frontCameraUnavailable
	case couldNotCaptureInput(error: NSError)
	}
	
	enum LightError: Error {
	case torchUnavailable
	}
	
	override func pluginInitialize() {
	super.pluginInitialize()
	NotificationCenter.default.addObserver(self, selector: #selector(pageDidLoad), name: NSNotification.Name.CDVPageDidLoad, object: nil)
	self.cameraView = CameraView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
	self.cameraView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
	}
	
	func sendErrorCode(command: CDVInvokedUrlCommand, error: QRScannerError){
	let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.rawValue)
	commandDelegate!.send(pluginResult, callbackId:command.callbackId)
	}
	
	// utility method
	@objc func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
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
	// Fallback for iOS < 8.0
	if(background != nil){
	background!()
	}
	if(completion != nil){
	completion!()
	}
	}
	}
	
	
	@objc(qrScanner:)
	func qrScanner (_ command: CDVInvokedUrlCommand,_ commond: startScanner,_ commond: stopScanner){
	let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
	commandDelegate!.send(pluginResult, callbackId:command.callbackId)
	
	}
	//Check method for startscanner and stopscanner.
	func  boolean execute(Action:String, JSONArray:[args]) -> bool{
	if (action.equals(ACTION_QR_SCANNER)){
	String type = args.String(0)
	switch (type) {
	
	case START_SCANNING:
	startScanner();
	break;
	
	case STOP_SCANNING:
	stopScanner();
	
	break;
	
	}
	}
	return true
	
	}
	
	// startScanner Method.
	@objc(startScanner:)
	
	func startScanner(_ command: CDVInvokedUrlCommand) {
	var pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)
	let startScanner = command.arguments[0] as? String ?? ""
	let screenTitle = command.arguments[1] as? String ?? "Scan QR Code."
	let displayText = command.arguments[2] as? String ?? "Point your phone to the QR code to scan it"
	let displayTextColor = command.arguments[3] as? String ?? "0b0b0b"
	let buttonText = command.arguments[4] as? String ?? "I don't have a QR Code"
	let showButton = command.arguments[5] as? Bool ?? false
	let isRtl = command.arguments[6] as? Bool ?? false
	
	print("Start Scanning Successfully.")
	pluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: "Start Scanning Successfully.")
	self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
	
	}
	
	}
	
	// stopScanner Method.
	@objc(stopScanner:)
	func stopScanner(_ command: CDVInvokedUrlCommand) {
	
	print("Stop Scanning Successfully.")
	
	let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: "Stop Scanning Successfully.")
	self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
	
	}
