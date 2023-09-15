/**
 * Activity of Searching Network Printers
 *
 * @author Brother Industries, Ltd.
 * @version 2.2
 */

package com.brother.ptouch.sdk.printdemo;

import android.app.Activity;
import android.app.ListActivity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import com.brother.ptouch.sdk.NetPrinter;
import com.brother.ptouch.sdk.Printer;
import com.brother.ptouch.sdk.PrinterInfo;
import com.brother.ptouch.sdk.printdemo.common.Common;
import com.brother.ptouch.sdk.printdemo.common.MsgDialog;
import com.brother.sdk.lmprinter.*;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

@SuppressWarnings("ALL")
public class Activity_NetPrinterList extends ListActivity {

    // information
    private final MsgDialog mMsgDialog = new MsgDialog(this);
    private static final int SEARCH_TIME = 15; // sec
    private List<Channel> mPrinterList;
    private List<String> mItemList;

    /**
     * initialize activity
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        // get the modelName
        final Bundle extras = getIntent().getExtras();
        setContentView(R.layout.activity_netprinterlist);


        Button btnRefresh = (Button) findViewById(R.id.btnRefresh);
        btnRefresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                refreshButtonOnClick();

            }
        });


        Button btPrinterSettings = (Button) findViewById(R.id.btPrinterSettings);
        btPrinterSettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                settingsButtonOnClick();

            }
        });


        startSearch();

        this.setTitle(R.string.netPrinterListTitle_label);
    }

    /**
     * Called when [Settings] button is tapped
     */
    private void settingsButtonOnClick() {
        Intent wifiSettings = new Intent(
                android.provider.Settings.ACTION_WIFI_SETTINGS);
        startActivityForResult(wifiSettings, Common.ACTION_WIFI_SETTINGS);
    }

    /**
     * Called when [Refresh] button is tapped
     */
    private void refreshButtonOnClick() {
        startSearch();
    }

    private void startSearch() {
        mPrinterList = new ArrayList<>();
        mMsgDialog.showMsgWithButton("Net Printer", "Searching...", "Cancel", new Consumer<DialogInterface>() {
            @Override
            public void accept(DialogInterface dialogInterface) {
                PrinterSearcher.cancelNetworkSearch();
            }
        });
        Activity activity = this;
        new Thread(new Runnable(){
            public void run() {
                SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(activity);
                NetworkSearchOption option = new NetworkSearchOption(SEARCH_TIME, Boolean.parseBoolean(sharedPreferences
                        .getString("enabledTethering", "false")));
                PrinterSearchResult result = PrinterSearcher.startNetworkSearch(activity, option, new Consumer<Channel>() {
                    @Override
                    public void accept(Channel channel) {
                        mPrinterList.add(channel);
                        handleSearchRefresh(mPrinterList);
                    }
                });
                if((result.getError().getCode() == PrinterSearchError.ErrorCode.NoError) ||
                        (result.getError().getCode() == PrinterSearchError.ErrorCode.Canceled) ){
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

    /**
     * Called when the Settings activity exits
     */
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == Common.ACTION_WIFI_SETTINGS) {
            startSearch();
        }
    }

    /**
     * This method will be called when an item in the list is selected.
     *
     * @return
     */
    @Override
    protected void onListItemClick(ListView listView, View view, int position,
                                   long id) {

        final String item = (String) getListAdapter().getItem(position);
        if (!item.equalsIgnoreCase(getString(R.string.no_network_device))) {
            // send the selected printer info. to Settings Activity and close
            // the current Activity
            final Intent settings = new Intent(this, Activity_Settings.class);
            settings.putExtra("ipAddress", mPrinterList.get(position).getChannelInfo());
            String macAddress = mPrinterList.get(position).getExtraInfo().get(Channel.ExtraInfoKey.ModelName);
            settings.putExtra("macAddress", (macAddress == null)?"":macAddress);
            settings.putExtra("localName", "");
            String modelName = mPrinterList.get(position).getExtraInfo().get(Channel.ExtraInfoKey.ModelName);
            settings.putExtra("printer", (modelName == null)?"":modelName);
            setResult(RESULT_OK, settings);
        }
        finish();
    }

    private void handleSearchRefresh(List<Channel> printerList) {
        mItemList = new ArrayList<>();
        for (Channel channel: printerList) {
            String modelName = channel.getExtraInfo().get(Channel.ExtraInfoKey.ModelName);
            String macAddress = channel.getExtraInfo().get(Channel.ExtraInfoKey.MACAddress);
            String serialNumber = channel.getExtraInfo().get(Channel.ExtraInfoKey.SerialNubmer);
            String nodeName = channel.getExtraInfo().get(Channel.ExtraInfoKey.NodeName);
            mItemList.add(channel.getChannelInfo() + "\n"
                    + ((modelName == null)?"":modelName) + "\n"
                    + ((macAddress == null)?"":macAddress) + "\n"
                    + ((serialNumber == null)?"":serialNumber) + "\n"
                    + ((nodeName == null)?"":nodeName));
        }
        final ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.test_list_item, mItemList);
        this.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Activity_NetPrinterList.this.setListAdapter(adapter);
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