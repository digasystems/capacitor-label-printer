/**
 * Activity of printing pdf files
 *
 * @author Brother Industries, Ltd.
 * @version 2.2
 */

package com.brother.ptouch.sdk.printdemo;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.usb.UsbManager;
import android.os.Bundle;
import android.os.Message;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.Spinner;
import android.widget.TextView;

import com.brother.ptouch.sdk.PrinterInfo;
import com.brother.ptouch.sdk.printdemo.common.Common;
import com.brother.ptouch.sdk.printdemo.common.MsgDialog;
import com.brother.ptouch.sdk.printdemo.common.MsgHandle;
import com.brother.ptouch.sdk.printdemo.printprocess.PdfPrint;
import com.brother.sdk.lmprinter.Channel;
import com.brother.sdk.lmprinter.OpenChannelError;
import com.brother.sdk.lmprinter.PrintError;
import com.brother.sdk.lmprinter.PrinterDriver;
import com.brother.sdk.lmprinter.PrinterDriverGenerateResult;
import com.brother.sdk.lmprinter.PrinterDriverGenerator;
import com.brother.sdk.lmprinter.PrinterModel;
import com.brother.sdk.lmprinter.PrinterSearchResult;
import com.brother.sdk.lmprinter.PrinterSearcher;
import com.brother.sdk.lmprinter.V3PrinterService;
import com.brother.sdk.lmprinter.setting.MWPrintSettings;
import com.brother.sdk.lmprinter.setting.PJPrintSettings;
import com.brother.sdk.lmprinter.setting.PTPrintSettings;
import com.brother.sdk.lmprinter.setting.PrintSettings;
import com.brother.sdk.lmprinter.setting.QLPrintSettings;
import com.brother.sdk.lmprinter.setting.RJPrintSettings;
import com.brother.sdk.lmprinter.setting.TDPrintSettings;
import com.google.gson.Gson;

import java.util.ArrayList;

public class Activity_PrintPdf extends BaseActivity {

    private Spinner mSpinnerStartPage;
    private Spinner mSpinnerEndPage;
    private CheckBox mChkAllPages;
    private Button mBtnPrint;
    private SharedPreferences sharedPreferences;
    private String mFile;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_print_pdf);

        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this);

        // initialization for Activity
        mBtnPrint = (Button) findViewById(R.id.btnPrint);
        mBtnPrint.setEnabled(false);
        mBtnPrint.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                printButtonOnClick();
            }
        });

        Button btnSelectFile = (Button) findViewById(R.id.btnSelectFile);
        btnSelectFile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                selectFileButtonOnClick();
            }
        });

        Button btnModelSelect = (Button) findViewById(R.id.btnModelSelect);
        btnModelSelect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openV3ModelSelect();
            }
        });

        Button btnPrintSettings = (Button) findViewById(R.id.btnPrintSettings);
        btnPrintSettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openV4PrintSetting();
            }
        });


        // initialization for printing
        mDialog = new MsgDialog(this);
        mHandle = new MsgHandle(this, mDialog);
        myPrint = new PdfPrint(this, mHandle, mDialog);

        // set the adapter when printing by way of Bluetooth
        BluetoothAdapter bluetoothAdapter = super.getBluetoothAdapter();
        myPrint.setBluetoothAdapter(bluetoothAdapter);

        mSpinnerStartPage = (Spinner) findViewById(R.id.spinnerStartPage);
        mSpinnerEndPage = (Spinner) findViewById(R.id.spinnerEndPage);
        mSpinnerStartPage.setEnabled(false);
        mSpinnerEndPage.setEnabled(false);

        mChkAllPages = (CheckBox) this.findViewById(R.id.chkAllPages);
        mChkAllPages.setEnabled(false);
        mChkAllPages.setOnCheckedChangeListener(new OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton arg0, boolean arg1) {

                mSpinnerStartPage.setEnabled(!arg1);
                mSpinnerEndPage.setEnabled(!arg1);
            }
        });

        // get data from other application by way of intent sending
        final Bundle extras = getIntent().getExtras();
        if (extras != null) {
            String file = extras.getString(Common.INTENT_FILE_NAME);
            setPdfFile(file);
        }
    }

    /**
     * Called when [Select] button is tapped
     */
    @Override
    public void selectFileButtonOnClick() {

        // call File Explorer Activity to select a pdf file
        SharedPreferences prefs = PreferenceManager
                .getDefaultSharedPreferences(this);
        final String pdfPath = prefs.getString(Common.PREFES_PDF_PATH, "");
        final Intent fileList = new Intent(Activity_PrintPdf.this,
                Activity_FileList.class);
        fileList.putExtra(Common.INTENT_TYPE_FLAG, Common.FILE_SELECT_PDF);
        fileList.putExtra(Common.INTENT_FILE_NAME, pdfPath);
        startActivityForResult(fileList, Common.FILE_SELECT_PDF);

    }

    /**
     * Called when [Print] button is tapped
     */
    @Override
    public void printButtonOnClick() {
        if (!checkUSB())
            return;
        int startPage;
        int endPage;
        boolean allPages;

        // All pages
        if (mChkAllPages.isChecked()) {
            startPage = 1;
            endPage = mSpinnerEndPage.getCount();
            allPages = true;
        } else { // set pages
            startPage = Integer.parseInt((String) mSpinnerStartPage
                    .getSelectedItem());
            endPage = Integer.parseInt((String) mSpinnerEndPage
                    .getSelectedItem());
            allPages = false;
        }

        // error if startPage > endPage
        if (startPage > endPage) {
            mDialog.showAlertDialog(getString(R.string.msg_title_warning),
                    getString(R.string.error_input));
            return;
        }

        int[] pages;
        pages = new int[endPage - startPage + 1];
        int index = 0;
        for (int page = startPage; page <= endPage; page++) {
            pages[index] = page;
            index++;
        }

        // call function to print
        Activity_PrintPdf.V4PrinterThread printTread = new Activity_PrintPdf.V4PrinterThread(this, pages, allPages);
        printTread.start();

    }


    /**
     * Thread for printing
     */
    private class V4PrinterThread extends Thread {
        final Context context;
        final int[] pages;
        final boolean allPages;

        private V4PrinterThread(Context context, int[] pages, boolean allPages) {
            this.context = context;
            this.pages = pages;
            this.allPages = allPages;
        }

        private PrintSettings currentPrintSettings(final PrinterModel currentModel) {
            final String currentModelString = currentModel.name();
            Gson gson = new Gson();
            if(currentModelString.startsWith("QL")) {
                String qlPrintSettingsJson = sharedPreferences.getString("qlV4PrintSettings", "");
                if( qlPrintSettingsJson == "") {
                    return new QLPrintSettings(currentModel);
                }
                else {
                    return gson.fromJson(qlPrintSettingsJson, QLPrintSettings.class).copyPrintSettings(currentModel);
                }
            }
            else if(currentModelString.startsWith("PT")) {
                String ptPrintSettingsJson = sharedPreferences.getString("ptV4PrintSettings", "");
                if( ptPrintSettingsJson == "") {
                    return new PTPrintSettings(currentModel);
                }
                else {
                    return gson.fromJson(ptPrintSettingsJson, PTPrintSettings.class).copyPrintSettings(currentModel);
                }
            }
            else if(currentModelString.startsWith("PJ")) {
                String pjPrintSettingsJson = sharedPreferences.getString("pjV4PrintSettings", "");
                if( pjPrintSettingsJson == "") {
                    return new PJPrintSettings(currentModel);
                }
                else {
                    return gson.fromJson(pjPrintSettingsJson, PJPrintSettings.class).copyPrintSettings(currentModel);
                }
            }
            else if(currentModelString.startsWith("RJ")) {
                String rjPrintSettingsJson = sharedPreferences.getString("rjV4PrintSettings", "");
                if( rjPrintSettingsJson == "") {
                    return new RJPrintSettings(currentModel);
                }
                else {
                    return gson.fromJson(rjPrintSettingsJson, RJPrintSettings.class).copyPrintSettings(currentModel);
                }
            }
            else if(currentModelString.startsWith("TD")) {
                String tdPrintSettingsJson = sharedPreferences.getString("tdV4PrintSettings", "");
                if( tdPrintSettingsJson == "") {
                    return new TDPrintSettings(currentModel);
                }
                else {
                    return gson.fromJson(tdPrintSettingsJson, TDPrintSettings.class).copyPrintSettings(currentModel);
                }
            }
            else if(currentModelString.startsWith("MW")) {
                String mwPrintSettingsJson = sharedPreferences.getString("mwV4PrintSettings", "");
                if( mwPrintSettingsJson == "") {
                    return new MWPrintSettings(currentModel);
                }
                else {
                    return gson.fromJson(mwPrintSettingsJson, MWPrintSettings.class).copyPrintSettings(currentModel);
                }
            }

            return new QLPrintSettings(currentModel);
        }

        @Override
        public void run() {
            PrinterInfo.Model model = PrinterInfo.Model.valueOf(sharedPreferences
                    .getString("printerModel", ""));
            PrinterInfo.Port port = PrinterInfo.Port.valueOf(sharedPreferences
                    .getString("port", ""));
            String ipAddress = sharedPreferences.getString("address", "");
            String macAddress = sharedPreferences.getString("macAddress", "");
            String localName = sharedPreferences.getString("localName", "");

            Channel channel;
            switch (port) {
                case BLUETOOTH:
                    channel = Channel.newBluetoothChannel(macAddress, BluetoothAdapter.getDefaultAdapter()); break;
                case BLE:
                    channel = Channel.newBluetoothLowEnergyChannel(localName, context, BluetoothAdapter.getDefaultAdapter()); break;
                case USB:
                    PrinterSearchResult result;
                    result = PrinterSearcher.startUSBSearch(this.context);
                    if (result.getChannels().isEmpty()) {
                        channel = null;
                    }
                    else {
                        channel = result.getChannels().get(0);
                    }
                    break;
                case NET:
                    channel = Channel.newWifiChannel(ipAddress); break;
                default:
                    return;
            }

            if (channel == null) {
                mHandle.setResult("Channel not found");
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            // start message
            Message msg = mHandle.obtainMessage(Common.MSG_PRINT_START);
            mHandle.sendMessage(msg);

            // Create a `PrinterDriver` instance
            PrinterDriverGenerateResult result = PrinterDriverGenerator.openChannel(channel);
            if (result.getError().getCode() != OpenChannelError.ErrorCode.NoError) {
                mHandle.setResult(result.getError().getCode().toString());
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            PrinterDriver printerDriver = result.getDriver();

            Gson gson = new Gson();
            PrinterModel v4model = PrinterModel.valueOf(model.toString());

            // Initialize `PrintSettings`
            PrintSettings printSettings = currentPrintSettings(v4model);
            
            PrintError printError;
            // Print the image
            if (allPages) {
                printError = printerDriver.printPDF(mFile, printSettings);
            }
            else {
                printError = printerDriver.printPDF(mFile, pages, printSettings);
            }
            if (printError.getCode() != PrintError.ErrorCode.NoError) {
                printerDriver.closeChannel();
                mHandle.setResult(printError.toString());
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            printerDriver.closeChannel();

            // end message
            mHandle.setResult("Success");
            msg = mHandle.obtainMessage(Common.MSG_PRINT_END);
            mHandle.sendMessage(msg);
        }
    }

    /**
     * Called when an activity you launched exits, giving you the requestCode
     * you started it with, the resultCode it returned, and any additional data
     * from it.
     */
    @Override
    protected void onActivityResult(final int requestCode,
                                    final int resultCode, final Intent data) {

        super.onActivityResult(requestCode, resultCode, data);

        // get pdf File and set the new data to display
        if (resultCode == RESULT_OK && requestCode == Common.FILE_SELECT_PDF) {
            final String strRtn = data.getStringExtra(Common.INTENT_FILE_NAME);
            setPdfFile(strRtn);
        }
    }

    /**
     * set the pdf file for printing
     */
    private void setPdfFile(String file) {

        if (Common.isPdfFile(file)) {
            TextView txt = (TextView) findViewById(R.id.tvSelectedPdf);
            txt.setText(file);
            setSpinnerData(file);
            mChkAllPages.setEnabled(true);
            mChkAllPages.setChecked(true);
            mBtnPrint.setEnabled(true);
            mFile = file;
        }
    }

    /**
     * set the data of Spinners
     */
    private void setSpinnerData(String pdfFile) {

        // get the pages info. of the pdf file
        int pages = ((PdfPrint) myPrint).getPdfPages(pdfFile);
        String data[] = new String[pages];
        for (int i = 0; i < pages; i++) {
            data[i] = String.valueOf(i + 1);
        }

        // set the pages info. to display
        ArrayAdapter<CharSequence> adapter = new ArrayAdapter<CharSequence>(
                this, android.R.layout.simple_spinner_item, data);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mSpinnerStartPage.setAdapter(adapter);
        mSpinnerStartPage.setSelection(0);

        mSpinnerEndPage.setAdapter(adapter);
        mSpinnerEndPage.setSelection(pages - 1);

    }

    public void openV4PrintSetting() {
        Intent intent = new Intent(this, Activity_PrintSettingSeries.class);
        startActivity(intent);
    }

    public void openV3ModelSelect() {
        startActivity(new Intent(this, Activity_ModelSelect.class));
    }
}
