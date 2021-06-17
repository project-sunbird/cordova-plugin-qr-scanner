import Foundation
import AVFoundation

@author DineshKokare

@objc(QRScannerPlugin) class QRScannerPlugin : CordovaPlugin {   

let ACTION_QR_SCANNER = "qrScanner"	
let START_SCANNING = "startScanner"
let STOP_SCANNING = "stopScanner"

 private  var  mScanDialog:String? = nil
 private  var decoratedBarcodeView:String? = nil
 private  var  themeSelected:String?

func  boolean execute(Action:String, JSONArray:[args]) -> bool{
	 if (action.equals(ACTION_QR_SCANNER)){
		 String type = args.String(0)
		    switch (type) {
            case START_SCANNING:
             showScanDialog(args)
         break;
     case STOP_SCANNING:
     stopScanner();
      break;
         
	          }
	 }
	  return true

}

func getIdOfResource(_ command: CDVInvokedUrlCommand){
    var pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)
        let resourceType = command.arguments[0] as? String ?? ""
        let  name = command.arguments[1] as? String ?? ""
return cordova.getActivity().getResources().getIdentifier(name, resourceType,
cordova.getActivity().getApplicationInfo().packageName);
}

func sendErrorCode(command: CDVInvokedUrlCommand, error: QRScannerError){
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.rawValue)
        commandDelegate!.send(pluginResult, callbackId:command.callbackId)
    }


// startScanner Method.
    @objc(startScanner:)
    
func startScanner(_ command: CDVInvokedUrlCommand) {
    var pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_ERROR)
        let showButton = command.arguments[5] as? Bool ?? false
        let isRtl = command.arguments[4] as? Bool ?? false
        let screenTitle = command.arguments[0] as? String ??  "Scan QR Code"
        let displayText = command.arguments[1] as? String ?? "Point your phone to the QR code to scan it"
       let buttonText = command.arguments[2] as? String ?? "I don't have a QR Code"
       let displayTextColor = command.arguments[3] as? String ?? "0b0b0b"
      
      self.view = view(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
      self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight];

     self.Toolbar = Toolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
      self.Toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight];

	var ImageView = ImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
      self.ImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight];

}

	runOnUiThread(new Runnable(){  
 	
		
        }


       

    }
    

    // stopScanner Method.
    @objc(stopScanner:)
    func stopScanner(_ command: CDVInvokedUrlCommand) {
     cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
               
            }
        });

    }
  


