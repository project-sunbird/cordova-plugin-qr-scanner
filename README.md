# cordova-plugin-qr-scanner

This plugin provides QR Code scanning feature on Android and iOS devices. Plugin uses camera for scanning the QR code and returns the decoded value.


## Installation

With Ionic:

`ionic cordova plugin add cordova-plugin-qr-scanner`

With Cordova:

`cordova plugin add cordova-plugin-qr-scanner`

## API

### startScanner
To start scanning a QR code call this method. Once called the device will open camera and start looking for the QR code, once QR code is scanner succesfully, camera will close and returns the scanned data to callback function.

|Argument|Description|
|--|--|
|`screenTitle`|On camera screen top a text to be shown|
|`displayText`|Text to displayed below the title on camera screen|
|`displayTextColor`|Display text color|
|`buttonText`|Button text shown on camera screen|
|`showButton`|Wheather to show button or not, boolean value|
|`isRTL`|Is the App using right-to-left language direction or not, boolean value|
|`successCallback`|Success handler function|
|`errorCallback`|Error handler function|


```js
qrScanner.startScanner(screenTitle, displayText, displayTextColor, buttonText, showButton, isRTL,
  (scannedData) => {
    console.log('Success');
  }, (error) => {
    console.error('Failed to scann QR code');
});    
```

### stopScanner
If the scanning has to be stopped in between or to cancel scanning.

```js
qrScanner.stopScanner(successCallback, errorCallback);
```

## Support

|Platform|
|-|
|Android|
|iOS|
