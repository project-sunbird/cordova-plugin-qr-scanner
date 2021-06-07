import Foundation

@objc(QRScannerPlugin) class QRScannerPlugin : CordovaPlugin {   

let screenTitle : String? = ""

let displayText : String? = ""

let displayTextColor: String? = ""

let buttonText : String? = ""

let showButton : String? = ""

let isRtl = ""


// startScanner Method.
    @objc()
    startScanner:screenTitle, displayText, displayTextColor,
    buttonText, showButton, isRtl,success, error
    func startScanner(_ command: CDVInvokedUrlCommand) {

    }


    // stopScanner Method.
    @objc()
    stopScanner:success, error
    func stopScanner(_ command: CDVInvokedUrlCommand) {

    }
  

}
