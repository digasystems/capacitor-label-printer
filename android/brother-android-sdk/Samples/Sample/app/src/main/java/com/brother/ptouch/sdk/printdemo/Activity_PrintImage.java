/**
 * Activity of printing image/prn files
 *
 * @author Brother Industries, Ltd.
 * @version 2.2
 */
package com.brother.ptouch.sdk.printdemo;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.hardware.usb.UsbManager;
import android.os.Bundle;
import android.os.Message;
import android.preference.PreferenceManager;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.brother.ptouch.sdk.PrinterInfo;
import com.brother.ptouch.sdk.printdemo.common.Common;
import com.brother.ptouch.sdk.printdemo.common.MsgDialog;
import com.brother.ptouch.sdk.printdemo.common.MsgHandle;
import com.brother.ptouch.sdk.printdemo.printprocess.BasePrint;
import com.brother.ptouch.sdk.printdemo.printprocess.ImagePrint;
import com.brother.ptouch.sdk.printdemo.printprocess.MultiImagePrint;
import com.brother.sdk.lmprinter.Channel;
import com.brother.sdk.lmprinter.GetStatusError;
import com.brother.sdk.lmprinter.GetStatusResult;
import com.brother.sdk.lmprinter.OpenChannelError;
import com.brother.sdk.lmprinter.PrintError;
import com.brother.sdk.lmprinter.PrinterDriver;
import com.brother.sdk.lmprinter.PrinterDriverGenerateResult;
import com.brother.sdk.lmprinter.PrinterDriverGenerator;
import com.brother.sdk.lmprinter.PrinterModel;
import com.brother.sdk.lmprinter.PrinterSearchResult;
import com.brother.sdk.lmprinter.PrinterSearcher;
import com.brother.sdk.lmprinter.PrinterStatus;
import com.brother.sdk.lmprinter.PrinterStatusRawData;
import com.brother.sdk.lmprinter.setting.MWPrintSettings;
import com.brother.sdk.lmprinter.setting.PJPrintSettings;
import com.brother.sdk.lmprinter.setting.PTPrintSettings;
import com.brother.sdk.lmprinter.setting.QLPrintSettings;
import com.brother.sdk.lmprinter.setting.RJPrintSettings;
import com.brother.sdk.lmprinter.setting.TDPrintSettings;
import com.brother.sdk.lmprinter.setting.PrintSettings;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicBoolean;

import static com.brother.ptouch.sdk.printdemo.common.Common.UsbAuthorizationState.NOT_DETERMINED;

public class Activity_PrintImage extends BaseActivity {

    private final ArrayList<String> mFiles = new ArrayList<String>();
    private ImageView mImageView;
    private Button mBtnPrint;
    private Button mBtnModelSelect;
    private SharedPreferences sharedPreferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this);

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_print_image);


        Button btnSelectFile = (Button) findViewById(R.id.btnSelectFile);
        btnSelectFile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                selectFileButtonOnClick();
            }
        });

        Button btnPrinterSettings = (Button) findViewById(R.id.btnPrintSettings);
        btnPrinterSettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openV4PrintSetting();
            }
        });

        Button btnPrinterStatus = (Button) findViewById(R.id.btnPrinterStatus);
        btnPrinterStatus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                printerStatusButtonOnClick();

            }
        });
        Button btnSendFile = (Button) findViewById(R.id.btnSendFile);
        btnSendFile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                sendFileButtonOnClick();

            }
        });

        // initialization for Activity
        mBtnPrint = (Button) findViewById(R.id.btnPrint);
        mBtnPrint.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                printButtonOnClick();

            }
        });

        mBtnModelSelect = (Button) findViewById(R.id.btnModelSelect);
        mBtnModelSelect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openV3ModelSelect();

            }
        });

        mBtnPrint.setEnabled(false);

        CheckBox chkMutilSelect = (CheckBox) this
                .findViewById(R.id.chkMultipleSelect);
        chkMutilSelect
                .setOnCheckedChangeListener(new OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton arg0,
                                                 boolean arg1) {
                        showMultiSelect(arg1);
                    }
                });

        mImageView = (ImageView) this.findViewById(R.id.imageView);

        // get data from other application by way of intent sending
        final Bundle extras = getIntent().getExtras();
        if (extras != null) {
            String file = extras.getString(Common.INTENT_FILE_NAME);
            setDisplayFile(file);
            mBtnPrint.setEnabled(true);
        }

        // initialization for printing
        mDialog = new MsgDialog(this);
        mHandle = new MsgHandle(this, mDialog);
        myPrint = new ImagePrint(this, mHandle, mDialog);

        // when use bluetooth print set the adapter
        BluetoothAdapter bluetoothAdapter = super.getBluetoothAdapter();
        myPrint.setBluetoothAdapter(bluetoothAdapter);
    }

    /**
     * Called when [select file] button is tapped
     */
    @Override
    public void selectFileButtonOnClick() {

        SharedPreferences prefs = PreferenceManager
                .getDefaultSharedPreferences(this);

        // call File Explorer Activity to select a image or prn file
        final String imagePrnPath = prefs.getString(
                Common.PREFES_IMAGE_PRN_PATH, "");
        final Intent fileList = new Intent(Activity_PrintImage.this,
                Activity_FileList.class);
        fileList.putExtra(Common.INTENT_TYPE_FLAG, Common.FILE_SELECT_PRN_IMAGE);
        fileList.putExtra(Common.INTENT_FILE_NAME, imagePrnPath);
        startActivityForResult(fileList, Common.FILE_SELECT_PRN_IMAGE);
    }

    /**
     * Called when [Print] button is tapped
     */
    @Override
    public void printButtonOnClick() {
        // set the printing data
        ((ImagePrint) myPrint).setFiles(mFiles);

        if (!checkUSB())
            return;

        V4PrinterThread printTread = new V4PrinterThread(this);
        printTread.start();
    }

    /**
     * Thread for printing
     */
    private class V4PrinterThread extends Thread {
        final Context context;

        private V4PrinterThread(Context context) {
            this.context = context;
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
            AtomicBoolean flagCancel = new AtomicBoolean(false);

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

            mHandle.setCancelBlock(()->{
                flagCancel.set(true);
            });

            mHandle.sendMessage(msg);

            if ( flagCancel.get()) {
                mHandle.setResult("Canceled");
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            // Create a `PrinterDriver` instance
            PrinterDriverGenerateResult result = PrinterDriverGenerator.openChannel(channel);
            if (result.getError().getCode() != OpenChannelError.ErrorCode.NoError) {
                mHandle.setResult(result.getError().getCode().toString());
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            final PrinterDriver printerDriver = result.getDriver();
            mHandle.setCancelBlock(()->{
                printerDriver.cancelPrinting();
                flagCancel.set(true);
            });
            Gson gson = new Gson();
            PrinterModel v4model = PrinterModel.valueOf(model.toString());

            // Initialize `PrintSettings`
            PrintSettings printSettings = currentPrintSettings(v4model);

            String[] FilePaths = mFiles.toArray(new String[mFiles.size()]);

            if ( flagCancel.get()) {
                mHandle.setResult("Canceled");
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }
            // Print the image
            PrintError printError = printerDriver.printImage(FilePaths, printSettings);
            if (printError.getCode() != PrintError.ErrorCode.NoError) {
                printerDriver.closeChannel();
                mHandle.setResult(printError.toString());
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            printerDriver.closeChannel();

            // end message
            mHandle.setResult("Success\n\n" + printError.toString());
            msg = mHandle.obtainMessage(Common.MSG_PRINT_END);
            mHandle.sendMessage(msg);
        }
    }

    /**
     * Called when [Print] button is tapped
     */
    public void printMultiFileButtonOnClick() {
        myPrint = new MultiImagePrint(this, mHandle, mDialog);

        // set the printing data
        ((MultiImagePrint) myPrint).setFiles(mFiles);

        if (!checkUSB())
            return;

        // call function to print
        myPrint.print();

        myPrint = new ImagePrint(this, mHandle, mDialog);
    }

    /**
     * Called when [Printer Status] button is tapped
     */
    private void printerStatusButtonOnClick() {
        if (!checkUSB())
            return;

        V4PrinterStatusThread getStatusThread = new V4PrinterStatusThread(this);
        getStatusThread.start();
    }


    /**
     * Thread for printing
     */
    private class V4PrinterStatusThread extends Thread {
        final Context context;

        private V4PrinterStatusThread(Context context) {
            this.context = context;
        }

        private String PrinterStatusMessage(final PrinterStatus status) {
            String statusString = "";
            statusString += String.format("Status Raw: ");
            PrinterStatusRawData rawStatus = status.getRawData();
            for(int i = 0; i < rawStatus.getStatusBytes().length; i++) {
                statusString += String.format("%02x, ", rawStatus.getStatusBytes()[i]);
            }
            statusString += String.format("\n");
            statusString += String.format("model: %s\n", status.getModel().toString());
            statusString += String.format("errorCode: %s\n", status.getErrorCode().toString());

            if (status.getBatteryStatus() != null) {
                statusString += String.format("batteryStatus.batteryMounted: %s\n", status.getBatteryStatus().getBatteryMounted().toString());
                statusString += String.format("batteryStatus.charging: %s\n", status.getBatteryStatus().getCharging().toString());
                statusString += String.format("batteryStatus.chargeLevel: %d/%d\n", status.getBatteryStatus().getChargeLevel().getCurrent(), status.getBatteryStatus().getChargeLevel().getMax());
            }
            else {
                statusString += String.format("batteryStatus: null\n");
            }

            if (status.getMediaInfo() != null) {
                statusString += String.format("mediaInfo.mediaType: %s\n", status.getMediaInfo().getMediaType().toString());
                statusString += String.format("mediaInfo.backgroundColor: %s\n", status.getMediaInfo().getBackgroundColor().toString());
                statusString += String.format("mediaInfo.inkColor: %s\n", status.getMediaInfo().getInkColor().toString());
                if (status.getMediaInfo().isHeightInfinite()) {
                    statusString += String.format("mediaInfo.(width, height): (%d, ∞)\n", status.getMediaInfo().getWidth_mm());
                }
                else {
                    statusString += String.format("mediaInfo.(width, height): (%d, %d)\n", status.getMediaInfo().getWidth_mm(), status.getMediaInfo().getHeight_mm());
                }

                PTPrintSettings.LabelSize ptSize = status.getMediaInfo().getPTLabelSize();
                if (ptSize != null) {
                    statusString += String.format("mediaInfo getPTLabelSize: %s\n", ptSize.toString());
                }
                QLPrintSettings.LabelSize qlSize = status.getMediaInfo().getQLLabelSize();
                if (qlSize != null) {
                    statusString += String.format("mediaInfo getQLLabelSize: %s\n", qlSize.toString());
                }
            }
            else {
                statusString += String.format("mediaInfo: null\n");
            }
            return statusString;
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
            AtomicBoolean flagCancel = new AtomicBoolean(false);

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
            mHandle.setCancelBlock(()->{
                flagCancel.set(true);
            });

            mHandle.sendMessage(msg);

            if ( flagCancel.get()) {
                mHandle.setResult("Canceled");
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }


            // Create a `PrinterDriver` instance
            PrinterDriverGenerateResult result = PrinterDriverGenerator.openChannel(channel);
            if (result.getError().getCode() != OpenChannelError.ErrorCode.NoError) {
                mHandle.setResult(result.getError().getCode().toString());
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            final PrinterDriver printerDriver = result.getDriver();
            mHandle.setCancelBlock(()->{
                printerDriver.cancelPrinting();
                flagCancel.set(true);
            });

            Gson gson = new Gson();
            PrinterModel v4model = PrinterModel.valueOf(model.toString());

            if ( flagCancel.get()) {
                mHandle.setResult("Canceled");
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            GetStatusResult statusResult = printerDriver.getPrinterStatus();

            if (statusResult.getError().getCode() != GetStatusError.ErrorCode.NoError) {
                printerDriver.closeChannel();
                mHandle.setResult(statusResult.getError().toString());
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            printerDriver.closeChannel();

            // end message
            mHandle.setResult(PrinterStatusMessage(statusResult.getPrinterStatus()));
            msg = mHandle.obtainMessage(Common.MSG_PRINT_END);
            mHandle.sendMessage(msg);
        }
    }

    /**
     * Called when [Printer Status] button is tapped
     */
    private void sendFileButtonOnClick() {

        // set the printing data
        ((ImagePrint) myPrint).setFiles(mFiles);

        if (!checkUSB())
            return;

        sendFile();
    }


    /**
     * Launch the thread to print
     */
    private void sendFile() {


        SendFileThread getTread = new SendFileThread();
        getTread.start();
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

        // set the image/prn file
        if (resultCode == RESULT_OK
                && requestCode == Common.FILE_SELECT_PRN_IMAGE) {
            final String strRtn = data.getStringExtra(Common.INTENT_FILE_NAME);
            setImageOrPrnFile(strRtn);
        }
    }

    /**
     * set the image/prn file
     */
    private void setImageOrPrnFile(String file) {
        CheckBox chkMultiSelect = (CheckBox) this
                .findViewById(R.id.chkMultipleSelect);
        TextView tvSelectedFiles = (TextView) findViewById(R.id.tvSelectedFiles);

        if (chkMultiSelect.isChecked()) {
            if (!mFiles.contains(file)) {
                mFiles.add(file);

                int count = mFiles.size();
                String str = "";
                for (int i = 0; i < count; i++) {
                    str = str + mFiles.get(i) + "\n";
                }
                tvSelectedFiles.setText(str);
            }
        } else {
            setDisplayFile(file);
        }
        mBtnPrint.setEnabled(true);
    }

    /**
     * set the selected file to display
     */
    @SuppressWarnings("deprecation")
    private void setDisplayFile(String file) {
        mFiles.clear();
        mFiles.add(file);

        ((TextView) findViewById(R.id.tvSelectedFiles)).setText(file);
        if (Common.isImageFile(file)) {

            WindowManager windowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
            Display display = windowManager.getDefaultDisplay();
            int displayWidth = display.getWidth();
            int displayHeight = display.getHeight();

            int[] location = new int[2];
            Button btnPrint = (Button)findViewById(R.id.btnPrint);
            btnPrint.getLocationOnScreen(location);

            int height = displayHeight - location[1] - btnPrint.getHeight();
            Bitmap mBitmap = Common.fileToBitmap(file, displayWidth, height);

            mImageView.setImageBitmap(mBitmap);
        } else {
            mImageView.setImageBitmap(null);
        }
    }

    /**
     * set the status of controls when the [Multi Select] CheckBox is checked or
     * not
     */
    private void showMultiSelect(boolean isVisible) {
        mFiles.clear();
        mBtnPrint.setEnabled(false);

        TextView tvSelectedFiles = (TextView) findViewById(R.id.tvSelectedFiles);
        tvSelectedFiles.setText("");

        if (isVisible) {
            mImageView.setImageBitmap(null);
        }
    }

    /**
     * Thread for getting the printer's status
     */
    private class SendFileThread extends Thread {
        @Override
        public void run() {

            // set info. for printing
            BasePrint.BasePrintResult setPrinterInfoResult = myPrint.setPrinterInfo();
            if (setPrinterInfoResult.success == false) {
                mHandle.setResult(setPrinterInfoResult.errorMessage);
                mHandle.sendMessage(mHandle.obtainMessage(Common.MSG_PRINT_END));
                return;
            }

            // start message
            Message msg = mHandle.obtainMessage(Common.MSG_PRINT_START);
            mHandle.sendMessage(msg);

            myPrint.getPrinter().startCommunication();

            int count = ((ImagePrint) myPrint).getFiles().size();

            for (int i = 0; i < count; i++) {

                String strFile = ((ImagePrint) myPrint).getFiles().get(i);

                myPrint.setPrintResult(myPrint.getPrinter().sendBinaryFile(strFile));

                // if error, stop print next files
                if (myPrint.getPrintResult().errorCode != PrinterInfo.ErrorCode.ERROR_NONE) {
                    break;
                }
            }


            myPrint.getPrinter().endCommunication();

            // end message
            mHandle.setResult(myPrint.showResult());
            mHandle.setBattery(myPrint.getBatteryDetail());
            msg = mHandle.obtainMessage(Common.MSG_PRINT_END);
            mHandle.sendMessage(msg);

        }
    }

    public void openV4PrintSetting() {
        Intent intent = new Intent(this, Activity_PrintSettingSeries.class);
        startActivity(intent);
    }

    public void openV3ModelSelect() {
        startActivity(new Intent(this, Activity_ModelSelect.class));
    }
}
