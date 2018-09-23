package org.sunbird;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
//import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.widget.Button;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
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

/**
 * @author vinayagasundar
 */
public class QRScanner extends CordovaPlugin {

    private static final String ACTION_QR_SCANNER = "qrScanner";

    private static final String START_SCANNING = "startScanner";
    private static final String STOP_SCANNING = "stopScanner";

    private Dialog mScanDialog = null;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION_QR_SCANNER)) {
            String type = args.getString(0);

            switch (type) {
            case START_SCANNING:
                showScanDialog(args, callbackContext);
                break;

            case STOP_SCANNING:
                stopScanner(callbackContext);
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
        stopScanner(null);

        if (cordova.getActivity().isFinishing()) {
            return;
        }

        Log.i("hello", cordova.getActivity().getPackageName());

        String title = args.optString(1, "Point your phone to the QR code to scan it");

        String displayText = args.optString(2, "Skip");
        String color = args.optString(3, "#0b0b0b");
        boolean buttonUI = args.optBoolean(4, false);
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Context context = webView.getContext();

                View view = LayoutInflater.from(context).inflate(getIdOfResource("qr_scanner_dialog", "layout"), null);

                // Toolbar toolbar = view.findViewById(getIdOfResource("toolbar", "id"));
                // toolbar.setTitle(title);
                //
                // toolbar.setNavigationIcon(getIdOfResource("ic_action_arrow_left",
                // "drawable"));
                // toolbar.setNavigationOnClickListener(new View.OnClickListener() {
                // @Override
                // public void onClick(View v) {
                // stopScanner(callbackContext);
                // }
                // });
                Button button_skip = view.findViewById(getIdOfResource("button_skip", "id"));
                if (buttonUI) {
                    button_skip.setVisibility(View.INVISIBLE);
                } else {
                    button_skip.setVisibility(View.VISIBLE);
                }
                button_skip.setText(displayText);
                button_skip.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        stopScanner(callbackContext);
                    }
                });
                DecoratedBarcodeView decoratedBarcodeView = view.findViewById(getIdOfResource("qr_scanner", "id"));
                TextView titleTextView = view.findViewById(getIdOfResource("display_text", "id"));
                decoratedBarcodeView.setStatusText(null);

                titleTextView.setText(title);
                titleTextView.setTextColor(Color.parseColor(color));

                decoratedBarcodeView.decodeSingle(new BarcodeCallback() {
                    @Override
                    public void barcodeResult(BarcodeResult result) {
                        Log.i("QRScanner", "barcodeResult: " + result.getText());
                        decoratedBarcodeView.pause();
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

                mScanDialog.setContentView(view);
                // mScanDialog.setCancelable(false);

                mScanDialog.setOnKeyListener(new DialogInterface.OnKeyListener() {
                    @Override
                    public boolean onKey(DialogInterface dialogInterface, int i, KeyEvent keyEvent) {
                        if (keyEvent.getKeyCode() == KeyEvent.KEYCODE_BACK) {
                            stopScanner(callbackContext);
                            return true;
                        }
                        return false;
                    }
                });

                mScanDialog.show();
                decoratedBarcodeView.resume();
            }
        });
    }

    private void stopScanner(CallbackContext callbackContext) {
        if (mScanDialog != null && mScanDialog.isShowing()) {
            mScanDialog.dismiss();
        }

        mScanDialog = null;

        if (callbackContext != null) {
            callbackContext.success("cancel");
        }
    }
}
