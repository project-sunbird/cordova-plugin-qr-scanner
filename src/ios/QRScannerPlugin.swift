import Foundation

@author DineshKokare

@objc(QRScannerPlugin) class QRScannerPlugin : CordovaPlugin {   

let screenTitle : String? = ""

let displayText : String? = ""

let displayTextColor: String? = ""

let buttonText : String? = ""

let showButton : String? = ""

let isRtl = ""

private var ACTION_QR_SCANNER: String? = qrScanner
private var START_SCANNING: String? = startScanner
private var STOP_SCANNING: String? = stopScanner



// startScanner Method.
    @objc(StartScanner:)
    startScanner:screenTitle, displayText, displayTextColor,
    buttonText, showButton, isRtl,success, error
    func startScanner(_ command: CDVInvokedUrlCommand) {

    }
  

    // stopScanner Method.
    @objc(stopScanner:)
    stopScanner:success, error
    func stopScanner(_ command: CDVInvokedUrlCommand) {

    }
  

}
