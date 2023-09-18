package com.digasystems.capacitorlabelprinter;

// Android imports
import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
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

    private List<InetAddress> addresses;
    private List<InetAddress> ipv6Addresses;
    private List<InetAddress> ipv4Addresses;
    private String hostname;
    private RegistrationManager registrationManager;
    private BrowserManager browserManager;
    private Activity activity;

    public void initialize(Activity activity) {
        this.activity = activity;

        try {
            addresses = new CopyOnWriteArrayList<>();
            ipv6Addresses = new CopyOnWriteArrayList<>();
            ipv4Addresses = new CopyOnWriteArrayList<>();
            List<NetworkInterface> interfaces = Collections.list(NetworkInterface.getNetworkInterfaces());
            for (NetworkInterface networkInterface : interfaces) {
                if (networkInterface.supportsMulticast()) {
                    List<InetAddress> addresses = Collections.list(networkInterface.getInetAddresses());
                    for (InetAddress address : addresses) {
                        if (!address.isLoopbackAddress()) {
                            if (address instanceof Inet6Address) {
                                this.addresses.add(address);
                                ipv6Addresses.add(address);
                            } else if (address instanceof Inet4Address) {
                                this.addresses.add(address);
                                ipv4Addresses.add(address);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }

        Log.d(TAG, "Addresses " + addresses);

        try {
            hostname = getHostNameFromActivity(activity);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }

        Log.d(TAG, "Hostname " + hostname);

        Log.v(TAG, "Initialized");
    }

    public String getHostname() {
        Log.d(TAG, "Hostname: " + hostname);
        return hostname;
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

    public ServiceInfo registerService(String type, String domain, String name, int port, JSObject props, String addressFamily)
        throws IOException, RuntimeException {
        Log.d(TAG, "Register " + type + domain);
        if (registrationManager == null) {
            List<InetAddress> selectedAddresses = addresses;
            if ("ipv6".equalsIgnoreCase(addressFamily)) {
                selectedAddresses = ipv6Addresses;
            } else if ("ipv4".equalsIgnoreCase(addressFamily)) {
                selectedAddresses = ipv4Addresses;
            }
            registrationManager = new RegistrationManager(selectedAddresses, hostname);
        }

        ServiceInfo service = registrationManager.register(type, domain, name, port, props);
        if (service == null) {
            throw new RuntimeException("Failed to register");
        }
        return service;
    }

    public void unregisterService(String type, String domain, String name) {
        Log.d(TAG, "Unregister " + type + domain);

        if (registrationManager != null) {
            registrationManager.unregister(type, domain, name);
        }
    }

    public void stop() throws IOException {
        Log.d(TAG, "Stop");

        final RegistrationManager rm = registrationManager;
        registrationManager = null;
        if (rm != null) {
            rm.stop();
        }
    }

    public void watchService(String type, String domain, String addressFamily, LabelPrinterServiceWatchCallback callback)
        throws IOException, RuntimeException {
        Log.d(TAG, "Watch " + type + domain);

        if (browserManager == null) {
            List<InetAddress> selectedAddresses = addresses;
            if ("ipv6".equalsIgnoreCase(addressFamily)) {
                selectedAddresses = ipv6Addresses;
            } else if ("ipv4".equalsIgnoreCase(addressFamily)) {
                selectedAddresses = ipv4Addresses;
            }
            browserManager = new BrowserManager(activity, selectedAddresses, hostname);
            browserManager.watch(type, domain, callback);
        }
    }

    public void unwatchService(String type, String domain) {
        Log.d(TAG, "Unwatch " + type + domain);
        if (browserManager != null) {
            browserManager.unwatch(type, domain);
        }
    }

    public void close() throws IOException {
        Log.d(TAG, "Close");

        if (browserManager != null) {
            final BrowserManager bm = browserManager;
            browserManager = null;
            bm.close();
        }
    }

    private static String getHostNameFromActivity(Activity activity)
        throws NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
        @SuppressLint("DiscouragedPrivateApi")
        Method getString = Build.class.getDeclaredMethod("getString", String.class);
        getString.setAccessible(true);
        String hostName = Objects.requireNonNull(getString.invoke(null, "net.hostname")).toString();

        // Fix for Bug https://github.com/becvert/cordova-plugin-zeroconf/issues/93
        // "unknown" seams a possible result since Android Oreo (8).
        // https://android-developers.googleblog.com/2017/04/changes-to-device-identifiers-in.html
        // Observed with: Android 8 on a Samsung S9,
        // Android 10 an 11 on a Samsung S10,
        // Android 11 on AVD Emulator

        if (TextUtils.isEmpty(hostName) || hostName.equals("unknown")) {
            // API 26+ :
            // Querying the net.hostname system property produces a null result
            @SuppressLint("HardwareIds")
            String id = Settings.Secure.getString(activity.getContentResolver(), Settings.Secure.ANDROID_ID);
            hostName = "android-" + id;
        }
        return hostName;
    }
}