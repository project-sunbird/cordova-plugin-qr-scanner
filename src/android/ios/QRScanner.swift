import Foundation

@objc(QRScanner) class QRScanner : CordovaPlugin { 
let screenTitle = ""
let displayText = ""
let displayTextColor ""
let buttonText = ""
let showButton = ""
let isRtl = ""

// startScanner Method.
    @objc(startScanner:screenTitle, displayText, displayTextColor,
    buttonText, showButton, isRtl, success, error)
    func startScanner(_ command: CDVInvokedUrlCommand) {
      

    }

    // stopScanner Method.
    @objc(stopScanner:success, error)
    func stopScanner(_ command: CDVInvokedUrlCommand) {

    }
  

}
