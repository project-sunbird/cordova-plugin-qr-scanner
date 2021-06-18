import Foundation

@author DineshKokare

@objc(QRScannerPlugin) class QRScannerPlugin : CDVPlugin {   

@objc(qrScanner:)
func qrScanner (_ command: CDVInvokedUrlCommand){


}

//send errorcode.
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
  


