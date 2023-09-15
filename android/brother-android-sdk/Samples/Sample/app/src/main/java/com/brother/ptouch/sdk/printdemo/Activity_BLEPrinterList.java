package com.brother.ptouch.sdk.printdemo;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.ListActivity;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.brother.ptouch.sdk.BLEPrinter;
import com.brother.ptouch.sdk.Printer;
import com.brother.ptouch.sdk.printdemo.common.MsgDialog;
import com.brother.sdk.lmprinter.*;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

public class Activity_BLEPrinterList extends ListActivity {
    private static final int REQUEST_CODE_FINE_LOCATION_BLUETOOTH = 1;
    private static final int SEARCH_TIME = 5000; // msec
    private final MsgDialog mMsgDialog = new MsgDialog(this);
    private List<Channel> mPrinterList;
    private List<String> mItemList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bleprinterlist);
        this.setTitle("BLE Printer");

        findViewById(R.id.btnRefresh).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                checkPermissionThenStartSearch();
            }
        });

        // TODO:
        findViewById(R.id.btPrinterSettings).setEnabled(false);

        checkPermissionThenStartSearch();
    }

    @Override
    protected void onListItemClick(ListView listView, View view, int position, long id) {
        final Channel channel = mPrinterList.get(position);
        final Intent settings = new Intent(this, Activity_Settings.class);
        settings.putExtra("ipAddress", "");
        settings.putExtra("macAddress", "");
        settings.putExtra("localName", channel.getChannelInfo());
        String modelName = mPrinterList.get(position).getExtraInfo().get(Channel.ExtraInfoKey.ModelName);
        settings.putExtra("printer", (modelName == null)?"": modelName);
        setResult(RESULT_OK, settings);
        finish();
    }

    @TargetApi(Build.VERSION_CODES.M)
    private void checkPermissionThenStartSearch() {
        ArrayList<String> needPermission = new ArrayList<String>();
        // 実行時パーミッションが必要な OS でパーミッションが付加されていなければリクエストする
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && (
                (checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED) ||
                (checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED)
                )
        ) {
            needPermission.add(Manifest.permission.BLUETOOTH_SCAN);
            needPermission.add(Manifest.permission.BLUETOOTH_CONNECT);

        }
        else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) ||
                (checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) )
        {
            needPermission.add(Manifest.permission.ACCESS_FINE_LOCATION);
            needPermission.add(Manifest.permission.ACCESS_COARSE_LOCATION);
        }

        if(!needPermission.isEmpty()) {
            requestPermissions(needPermission.toArray(new String[needPermission.size()]), REQUEST_CODE_FINE_LOCATION_BLUETOOTH);
        }
        else {
            startSearch();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case REQUEST_CODE_FINE_LOCATION_BLUETOOTH: {
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    startSearch();
                }
            }
        }
    }

    private void startSearch() {
        mPrinterList = new ArrayList<>();
        mMsgDialog.showMsgWithButton("BLE Printer", "Searching...", "Cancel", new Consumer<DialogInterface>() {
            @Override
            public void accept(DialogInterface dialogInterface) {
                PrinterSearcher.cancelBLESearch();
            }
        });
        Activity activity = this;
        new Thread(new Runnable(){
            public void run() {
                BLESearchOption option = new BLESearchOption(SEARCH_TIME / 1000.0);
                PrinterSearchResult result = PrinterSearcher.startBLESearch(activity, option, new Consumer<Channel>() {
                    @Override
                    public void accept(Channel channel) {
                        mPrinterList.add(channel);
                        handleSearchRefresh(mPrinterList);
                    }
                });
                if((result.getError().getCode() == PrinterSearchError.ErrorCode.NoError) ||
                        (result.getError().getCode()== PrinterSearchError.ErrorCode.Canceled) ){
                    mPrinterList = result.getChannels();
                    handleSearchFinish(mPrinterList);
                }
                else {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            mMsgDialog.close();
                            mMsgDialog.showAlertDialog("Error", result.getError().toString());
                        }
                    });
                }
            }
        }).start();
    }

    private void handleSearchRefresh(List<Channel> printerList) {
        mItemList = new ArrayList<>();
        for (Channel channel: printerList) {
            String modelName = channel.getExtraInfo().get(Channel.ExtraInfoKey.ModelName);
            mItemList.add(channel.getChannelInfo() + "\n"
                    + ((modelName == null)?"":modelName) + "\n");
        }
        final ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.test_list_item, mItemList);
        this.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Activity_BLEPrinterList.this.setListAdapter(adapter);
            }
        });
    }

    private void handleSearchFinish(List<Channel> printerList) {
        handleSearchRefresh(printerList);
        this.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mMsgDialog.close();
            }
        });
    }
}
