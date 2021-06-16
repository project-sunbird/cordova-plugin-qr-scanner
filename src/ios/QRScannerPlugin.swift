import Foundation
import AVFoundation

@author DineshKokare

import Foundation

@objc(QRScannerPlugin) class QRScannerPlugin : CordovaPlugin {   

let ACTION_QR_SCANNER = "qrScanner"	
let START_SCANNING = "startScanner"
let STOP_SCANNING = "stopScanner"

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

// startScanner Method.
    @objc(startScanner:)
    
func startScanner(_ command: CDVInvokedUrlCommand) {
       
let screenTitle : String? = "Scan QR Code"

let displayText : String? = "Point your phone to the QR code to scan it"

let displayTextColor: String? = "#0b0b0b"

let buttonText : String? = "I don't have a QR Code"

let showButton : Boolean? = false

let isRtl :Boolean? = false


       

    }

    // stopScanner Method.
    @objc(stopScanner:)
    func stopScanner(_ command: CDVInvokedUrlCommand) {


    }
  

}
