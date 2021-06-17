import Foundation
import AVFoundation


@author DineshKokare


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

func getIdOfResource(String name, String resourceType){
return cordova.getActivity().getResources().getIdentifier(name, resourceType,
cordova.getActivity().getApplicationInfo().packageName);
}

func showScanDialog(JSONArray args){
	
	 stopScanner();
	  if ( args.isFinishing()){
     
      		 return;
       
 	  }

	let  appSharedPreferences = cordova.getActivity().getSharedPreferences("org.ekstep.genieservices.preference_file", Context.MODE_PRIVATE)
	let  themeSelected = appSharedPreferences.getString("current_selected_theme", "JOYFUL");
	
	let  String title = args.optString(1, "Scan QR Code");
    displayText.text = args.optString(2, "Point your phone to the QR code to scan it");
    displayText.backgroundcolor = args.optString(3, "#0b0b0b");
     buttonText.text = args.optString(4, "I don't have a QR Code");
	var showButton:Bool = args.optBoolean(5, false);
	var boolean isRtl = args.optBoolean(6, false);
	 
	Outlet-->var view = ""
        Outlet-->var Toolbar toolbar
	Outlet-->var ImageView imageView 

	runOnUiThread(new Runnable(){

		  if (!themeSelected.equalsIgnoreCase("JOYFUL")) {
			  view.setBackgroundColor(Color.parseColor("#f3f3f5"));

			  View view1 = view.findViewById(getIdOfResource("walkthrough_scan", "id"));

			  toolbar.setBackgroundColor(Color.parseColor("#f3f3f5"));

			   view1.setBackgroundColor(Color.parseColor("#f3f3f5"));
			   View oldScanLogoBackGround = view.findViewById(getIdOfResource("walkthrough_scan_image_layout", "id"));
			   oldScanLogoBackGround.setBackgroundColor(Color.parseColor("#f3f3f5"));
			  imageView = view.findViewById(getIdOfResource("joyful_new_scan_logo", "id"));
			  imageView.setVisibility(View.GONE);
			  ImageView oldScanScanLogo = view.findViewById(getIdOfResource("default_scan_logo", "id"));
   
                          oldScanScanLogo.setVisibility(View.VISIBLE);

		  }
			 toolbar.setTitle(title);

		  if (isRtl) {
                   
			 view.setLayoutDirection(View.LAYOUT_DIRECTION_RTL);
    
              		  toolbar.setNavigationIcon(getIdOfResource("ic_action_arrow_right", "drawable"));
    
            } else {
   
           
    		  toolbar.setNavigationIcon(getIdOfResource("ic_action_arrow_left", "drawable"));
    
            }

		 toolbar.setNavigationOnClickListener(new View.OnClickListener() {
      
              @Override
                   
	    public void onClick(View v) {
        
               		 callbackContext.success("cancel_nav_back");
             
      		 }
               
 		});
		
        }

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

if(self.prepScanner(command: command)){
            nextScanningCommand = command
            scanning = true
        }
       

    }

    // stopScanner Method.
    @objc(stopScanner:)
    func stopScanner(_ command: CDVInvokedUrlCommand) {
     (self.prepScanner(command: command)){
            scanning = false
            if(nextScanningCommand != nil){
                self.sendErrorCode(command: nextScanningCommand!, error: QRScannerError.scan_canceled)
            }
            self.getStatus(command)
        }

    }
  

}
