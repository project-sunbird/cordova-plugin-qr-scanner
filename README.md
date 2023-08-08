# cordova-plugin-qr-scanner
A highly-configurable QR code scanner made for Sunbird Mobile app - available for the iOS and Android platforms.

## Installation

    cordova plugin add https://github.com/project-sunbird/cordova-plugin-qr-scanner.git#<branch_name>

To install it locally 
    
    cordova plugin add <location_of plugin>/cordova-plugin-qr-scanner

# API Reference


* [qrScanner](#module_qrScanner)
    * [.startScanner(screenTitle, displayText, displayTextColor,buttonText, showButton, isRtl,successCallback, errorCallback)](#module_qrScanner.stopScanner)
    * [.stopScanner(successCallback, errorCallback)](#module_qrScanner.stopScanner)


## qrScanner
### qrScanner.startScanner(screenTitle, displayText, displayTextColor,buttonText, showButton, isRtl, successCallback, errorCallback)

Starts the camera to capture the QRCode and scanned result is sent in the successCallback. Following arguments arepassed to customize the qrScanner

- `screenTitle` represents toolbar title.
- `displayText` represents subtitle text.
- `displayTextColor` represents subtitle text color.
- `buttonText` represents button text .
- `showButton` represents whether to show Skip button or not.
- `isRtl` represents whether it the qrscanner supports RTL or not.

### qrScanner.stopScanner(successCallback, errorCallback)

Stops the scanner


