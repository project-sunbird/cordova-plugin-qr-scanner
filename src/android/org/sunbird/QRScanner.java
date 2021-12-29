package org.sunbird;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.zxing.ResultPoint;
import com.journeyapps.barcodescanner.BarcodeCallback;
import com.journeyapps.barcodescanner.BarcodeResult;
import com.journeyapps.barcodescanner.DecoratedBarcodeView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.List;
import java.util.Objects;

/**
 * @author vinayagasundar
 */
public class QRScanner extends CordovaPlugin {

    private static final String ACTION_QR_SCANNER = "qrScanner";

    private static final String START_SCANNING = "startScanner";
    private static final String STOP_SCANNING = "stopScanner";

    private Dialog mScanDialog = null;
    private DecoratedBarcodeView decoratedBarcodeView = null;
    private SharedPreferences appSharedPreferences;
    private String themeSelected;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION_QR_SCANNER)) {
            String type = args.getString(0);

            switch (type) {
            case START_SCANNING:
                showScanDialog(args, callbackContext);
                break;

            case STOP_SCANNING:
                stopScanner();
                break;
            }
        }

        return true;
    }

    private int getIdOfResource(String name, String resourceType) {
        return cordova.getActivity().getResources().getIdentifier(name, resourceType,
                cordova.getActivity().getApplicationInfo().packageName);
    }

    private void showScanDialog(JSONArray args, final CallbackContext callbackContext) throws JSONException {
        stopScanner();

        if (cordova.getActivity().isFinishing()) {
            return;
        }
        appSharedPreferences = cordova.getActivity().getSharedPreferences("org.ekstep.genieservices.preference_file", Context.MODE_PRIVATE);
        themeSelected = appSharedPreferences.getString("current_selected_theme", "JOYFUL");

        String title = args.optString(1, "Scan QR Code");
        String displayText = args.optString(2, "Point your phone to the QR code to scan it");
        String displayTextColor = args.optString(3, "#0b0b0b");
        String buttonText = args.optString(4, "I don't have a QR Code");
        boolean showButton = args.optBoolean(5, false);
        boolean isRtl = args.optBoolean(6, false);

        cordova.getActivity().runOnUiThread(new Runnable() {
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public void run() {
                Context context = webView.getContext();

                View view = LayoutInflater.from(context).inflate(getIdOfResource("qr_scanner_dialog", "layout"), null);

                Toolbar toolbar = view.findViewById(getIdOfResource("toolbar", "id"));
                TextView scannerTitle = view.findViewById(getIdOfResource("toolbarTextView", "id"));
                if (!themeSelected.equalsIgnoreCase("JOYFUL")) {
                    view.setBackgroundColor(Color.parseColor("#f3f3f5"));
                    View view1 = view.findViewById(getIdOfResource("walkthrough_scan", "id"));
                    toolbar.setBackgroundColor(Color.parseColor("#f3f3f5"));
                    view1.setBackgroundColor(Color.parseColor("#f3f3f5"));
                    View oldScanLogoBackGround = view.findViewById(getIdOfResource("walkthrough_scan_image_layout", "id"));
                    oldScanLogoBackGround.setBackgroundColor(Color.parseColor("#f3f3f5"));
                    ImageView imageView = view.findViewById(getIdOfResource("joyful_new_scan_logo", "id"));
                    imageView.setVisibility(View.GONE);
                    ImageView oldScanScanLogo = view.findViewById(getIdOfResource("default_scan_logo", "id"));
                    oldScanScanLogo.setVisibility(View.VISIBLE);
                }
                scannerTitle.setText(title);

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

                Button button_skip = view.findViewById(getIdOfResource("button_skip", "id"));
                if (showButton) {
                    button_skip.setVisibility(View.VISIBLE);
                } else {
                    button_skip.setVisibility(View.INVISIBLE);
                }
                button_skip.setText(buttonText);
                button_skip.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        callbackContext.success("skip");
                    }
                });

                decoratedBarcodeView = view.findViewById(getIdOfResource("qr_scanner", "id"));
                decoratedBarcodeView.setContentDescription("OR Scanner area");

                TextView titleTextView = view.findViewById(getIdOfResource("display_text", "id"));
                decoratedBarcodeView.setStatusText(null);

                titleTextView.setText(displayText);
                titleTextView.setTextColor(Color.parseColor(displayTextColor));

                decoratedBarcodeView.decodeSingle(new BarcodeCallback() {
                    @Override
                    public void barcodeResult(BarcodeResult result) {
                        Log.i("QRScanner", "barcodeResult: " + result.getText());
                        if (decoratedBarcodeView != null) {
                            decoratedBarcodeView.pause();
                        }
                        callbackContext.success(result.getText());
                    }

                    @Override
                    public void possibleResultPoints(List<ResultPoint> resultPoints) {

                    }
                });

                mScanDialog = new Dialog(context, android.R.style.Theme_Translucent_NoTitleBar);

                if ((cordova.getActivity().getWindow().getAttributes().flags
                        & WindowManager.LayoutParams.FLAG_FULLSCREEN) == WindowManager.LayoutParams.FLAG_FULLSCREEN) {

                    mScanDialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                            WindowManager.LayoutParams.FLAG_FULLSCREEN);
                }
                if (themeSelected.equalsIgnoreCase("JOYFUL")) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        Objects.requireNonNull(mScanDialog.getWindow()).addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
                        mScanDialog.getWindow().setStatusBarColor(Color.parseColor("#FFD954"));
                    }
                }

                mScanDialog.setContentView(view);

                if (mScanDialog != null) {
                    mScanDialog.setOnKeyListener(new DialogInterface.OnKeyListener() {
                        @Override
                        public boolean onKey(DialogInterface dialogInterface, int i, KeyEvent keyEvent) {
                            if (keyEvent.getKeyCode() == KeyEvent.KEYCODE_BACK) {
                                callbackContext.success("cancel_hw_back");
                                return true;
                            }
                            return false;
                        }
                    });
                }

                mScanDialog.show();
                decoratedBarcodeView.resume();
            }
        });
    }

    private void stopScanner() {
        if (mScanDialog != null && mScanDialog.isShowing()) {
            mScanDialog.dismiss();

        }
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (decoratedBarcodeView != null) {
                    decoratedBarcodeView.pause();
                    decoratedBarcodeView = null;
                }
            }
        });
        mScanDialog = null;

    }
}