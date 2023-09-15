/**
 * Message Dialog
 *
 * @author Brother Industries, Ltd.
 * @version 2.2
 */

package com.brother.ptouch.sdk.printdemo.common;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Message;

import com.brother.ptouch.sdk.printdemo.Activity_ScrollingText;
import com.brother.ptouch.sdk.printdemo.R;
import com.brother.ptouch.sdk.printdemo.printprocess.BasePrint;
import com.brother.sdk.lmprinter.Channel;

import java.util.function.Consumer;

@SuppressWarnings("ALL")
public class MsgDialog {

    private final Context mContext;
    private ProgressDialog mProgressDialog;
    private MsgHandle mHandle;
    private Activity mActivity;

    public MsgDialog(Activity activity) {
        mActivity = activity;
        mContext = activity;
    }

    /**
     * set handle
     */
    public void setHandle(MsgHandle handle) {

        mHandle = handle;
    }

    /**
     * show message
     */
    public void showStartMsgDialog(final String message) {

        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.dismiss();
        }

        mProgressDialog = new ProgressDialog(mContext);
        mProgressDialog.setMessage(message);
        mProgressDialog.setIndeterminate(true);
        mProgressDialog.setCancelable(false);
        mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        mProgressDialog.setButton(mContext.getString(R.string.button_cancel),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(final DialogInterface dialog,
                                        final int which) {
                        if (!mHandle.isExistCancelBlock()) {
                            BasePrint.cancel();
                        }
                        Message msg = mHandle
                                .obtainMessage(Common.MSG_PRINT_CANCEL);
                        mHandle.sendMessage(msg);
                        if (mHandle.isExistCancelBlock()) {
                            mHandle.execCancelBlock();
                        }
                    }
                });

        mProgressDialog.show();

    }

    /**
     * show the end message
     */
    public void showPrintCompleteMsgDialog(final String message) {

        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.dismiss();
        }

        mProgressDialog = new ProgressDialog(mContext);

        mProgressDialog.setMessage(mContext.getString(R.string.close_connect));
        mProgressDialog.setIndeterminate(true);
        mProgressDialog.setCancelable(false);
        mProgressDialog.setMessage(message);
        mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        mProgressDialog.setButton(mContext.getString(R.string.button_ok),
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i) {
                        dialog.cancel();
                    }
                });
        mProgressDialog.setButton2("Show all logs",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i) {
                        Intent intent = new Intent(mContext, Activity_ScrollingText.class);
                        intent.putExtra(Intent.EXTRA_TEXT, message);
                        mActivity.startActivity(intent);
                    }
                });
        mProgressDialog.show();

    }

    /**
     * update complete dialog's message
     */
    public void setMessage(String msg) {

        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.setMessage(msg);
        }
    }

    /**
     * show message
     */
    public void showMsgNoButton(final String title, final String message) {

        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.setMessage(message);
        }

        mProgressDialog = new ProgressDialog(mContext);
        mProgressDialog.setTitle(title);
        mProgressDialog.setMessage(message);
        mProgressDialog.setIndeterminate(true);
        mProgressDialog.setCancelable(false);
        mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        mProgressDialog.show();

    }

    public void showMsgWithButton(final String title, final String message, final String buttonCaption, Consumer<DialogInterface> buttonCallback) {

        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.setMessage(message);
        }

        mProgressDialog = new ProgressDialog(mContext);
        mProgressDialog.setTitle(title);
        mProgressDialog.setMessage(message);
        mProgressDialog.setIndeterminate(true);
        mProgressDialog.setCancelable(false);
        mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        mProgressDialog.setButton(buttonCaption,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(final DialogInterface dialog,
                                        final int which) {
                        buttonCallback.accept(dialog);
                    }
                });
        mProgressDialog.show();

    }

    /**
     * close dialog
     */
    public void close() {

        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.dismiss();
        }
    }

    /**
     * show alert dialog
     */
    public void showAlertDialog(String title, final String msg) {
        AlertDialog.Builder dialog = new AlertDialog.Builder(mContext);
        dialog.setTitle(title);
        dialog.setMessage(msg);
        dialog.setCancelable(false);
        dialog.setPositiveButton(R.string.button_ok, null);
        dialog.show();
    }

    public void disableCancel() {
        mProgressDialog.getButton(mProgressDialog.BUTTON_POSITIVE).setEnabled(
                false);
    }
}
