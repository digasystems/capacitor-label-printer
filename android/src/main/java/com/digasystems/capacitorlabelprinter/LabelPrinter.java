package com.digasystems.capacitorlabelprinter;

// Android imports
import static android.content.Context.NSD_SERVICE;
import static android.content.Context.WIFI_SERVICE;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.nsd.NsdManager;
import android.os.Build;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;

// Standard Java imports
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.CopyOnWriteArrayList;

// Third-party or library imports
import com.brother.sdk.lmprinter.PrinterDriver;
import com.brother.sdk.lmprinter.OpenChannelError;
import com.brother.sdk.lmprinter.PrinterModel;
import com.getcapacitor.JSObject;
import com.brother.sdk.lmprinter.Channel;
import com.brother.sdk.lmprinter.PrintError;
import com.brother.sdk.lmprinter.PrinterDriverGenerateResult;
import com.brother.sdk.lmprinter.PrinterDriverGenerator;
import com.brother.sdk.lmprinter.setting.QLPrintSettings;

// JmDNS imports
import javax.jmdns.ServiceInfo;


public class LabelPrinter {

    private static final String TAG = "LabelPrinter";
    private Activity activity;
    private NsdManager nsdManager;
    private NsdManager.DiscoveryListener discoveryListener;

    public void initialize(Activity activity, LabelPrinterPlugin lpp) {
        this.activity = activity;

        nsdManager = (NsdManager) activity.getApplicationContext().getSystemService(NSD_SERVICE);
        NetDiscoveryService discoveryListenerFactory = new NetDiscoveryService();
        discoveryListener = discoveryListenerFactory.initializeDiscoveryListener(nsdManager,lpp);

        Log.v(TAG, "Initialized");
    }

    public void printImage(String image, String ip, String printer, String label) {
        Channel channel = Channel.newWifiChannel(ip);

        PrinterDriverGenerateResult result = PrinterDriverGenerator.openChannel(channel);
        if (result.getError().getCode() != OpenChannelError.ErrorCode.NoError) {
            Log.e("", "Error - Open Channel: " + result.getError().getCode());
            return;
        }
        PrinterDriver printerDriver = result.getDriver();

        QLPrintSettings printSettings = new QLPrintSettings(PrinterModel.QL_810W); // printer
        printSettings.setLabelSize(QLPrintSettings.LabelSize.RollW103); // label

        byte[] decodedString = Base64.decode(image, Base64.DEFAULT);
        Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);

        PrintError printError = printerDriver.printImage(decodedByte, printSettings);
        if (printError.getCode() != PrintError.ErrorCode.NoError) {
            Log.d("", "Error - Print Image: " + printError.getCode());
        } else {
            Log.d("", "Success - Print Image");
        }
        printerDriver.closeChannel();
    }


    public void watchService(String type, String domain, String addressFamily, LabelPrinterServiceWatchCallback callback)
        throws IOException, RuntimeException {
        Log.d(TAG, "Watch " + type + domain);

        // Start service discovery
        nsdManager.discoverServices(type+domain, NsdManager.PROTOCOL_DNS_SD, discoveryListener);
    }

    public void unwatchService(String type, String domain) {
        Log.d(TAG, "Unwatch " + type + domain);
        nsdManager.stopServiceDiscovery(discoveryListener);
    }

    public void close() throws IOException {
        Log.d(TAG, "Close");

        nsdManager.stopServiceDiscovery(discoveryListener);
    }
}