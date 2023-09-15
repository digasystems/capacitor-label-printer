/**
 * Base Activity for printing
 *
 * @author Brother Industries, Ltd.
 * @version 2.2
 */

package com.brother.ptouch.sdk.printdemo;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.Build;
import android.os.Message;
import android.view.KeyEvent;

import com.brother.ptouch.sdk.PrinterInfo;
import com.brother.ptouch.sdk.printdemo.common.Common;
import com.brother.ptouch.sdk.printdemo.common.MsgDialog;
import com.brother.ptouch.sdk.printdemo.common.MsgHandle;
import com.brother.ptouch.sdk.printdemo.printprocess.BasePrint;
import com.brother.sdk.lmprinter.PrinterSearchError;
import com.brother.sdk.lmprinter.PrinterSearchResult;
import com.brother.sdk.lmprinter.PrinterSearcher;

import static com.brother.ptouch.sdk.printdemo.common.Common.UsbAuthorizationState.NOT_DETERMINED;
import static com.brother.ptouch.sdk.printdemo.common.Common.UsbAuthorizationState.APPROVED;
import static com.brother.ptouch.sdk.printdemo.common.Common.UsbAuthorizationState.DENIED;

public abstract class BaseActivity extends Activity {

    BasePrint myPrint = null;
    MsgHandle mHandle;
    MsgDialog mDialog;

    public abstract void selectFileButtonOnClick();

    public abstract void printButtonOnClick();

    /**
     * Called when [Printer Settings] button is tapped
     */
    void printerSettingsButtonOnClick() {
        startActivity(new Intent(this, Activity_Settings.class));
    }

    /**
     * show message when BACK key is clicked
     */
    @Override
    public boolean onKeyDown(final int keyCode, final KeyEvent event) {

        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
            showTips();
        }
        return false;
    }

    /**
     * show the BACK message
     */
    private void showTips() {

        final AlertDialog alertDialog = new AlertDialog.Builder(this)
                .setTitle(R.string.end_title)
                .setMessage(R.string.end_message)
                .setCancelable(false)
                .setPositiveButton(R.string.button_ok,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(final DialogInterface dialog,
                                                final int which) {

                                finish();
                            }
                        })
                .setNegativeButton(R.string.button_cancel,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(final DialogInterface dialog,
                                                final int which) {
                            }
                        }).create();
        alertDialog.show();
    }

    /**
     * get the BluetoothAdapter
     */
    BluetoothAdapter getBluetoothAdapter() {
        final BluetoothAdapter bluetoothAdapter = BluetoothAdapter
                .getDefaultAdapter();
        if (bluetoothAdapter != null && !bluetoothAdapter.isEnabled()) {
            final Intent enableBtIntent = new Intent(
                    BluetoothAdapter.ACTION_REQUEST_ENABLE);
            enableBtIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            try {
                startActivity(enableBtIntent);
            }
            catch (SecurityException e) { //権限がない
                return null;
            }
        }
        return bluetoothAdapter;
    }

    @TargetApi(12)
    boolean checkUSB() {
        if (myPrint.getPrinterInfo().port != PrinterInfo.Port.USB) {
            return true;
        }
        PrinterSearchResult result = PrinterSearcher.startUSBSearch(this);
        if (result.getError().getCode() == PrinterSearchError.ErrorCode.NotPermitted) {
            return false;
        }
        return true;
    }
}