package com.digasystems.capacitorlabelprinter;


import static android.content.Context.WIFI_SERVICE;

// Android imports
import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.wifi.WifiManager;
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
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
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
import javax.jmdns.JmDNS;
import javax.jmdns.ServiceEvent;
import javax.jmdns.ServiceInfo;
import javax.jmdns.ServiceListener;

public class LabelPrinter {

    private static final String TAG = "LabelPrinter";

    WifiManager.MulticastLock lock;
    private List<InetAddress> addresses;
    private List<InetAddress> ipv6Addresses;
    private List<InetAddress> ipv4Addresses;
    private String hostname;
    private RegistrationManager registrationManager;
    private BrowserManager browserManager;

    public void initialize(Activity activity) {
        WifiManager wifi = (WifiManager) activity.getApplicationContext().getSystemService(WIFI_SERVICE);
        lock = wifi.createMulticastLock("LabelPrinterPluginLock");
        lock.setReferenceCounted(false);

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

    public void printImage(String image, String ip) {
        Channel channel = Channel.newWifiChannel(ip);

        PrinterDriverGenerateResult result = PrinterDriverGenerator.openChannel(channel);
        if (result.getError().getCode() != OpenChannelError.ErrorCode.NoError) {
            Log.e("", "Error - Open Channel: " + result.getError().getCode());
            return;
        }
        PrinterDriver printerDriver = result.getDriver();

        QLPrintSettings printSettings = new QLPrintSettings(PrinterModel.QL_810W);
        printSettings.setLabelSize(QLPrintSettings.LabelSize.RollW103);

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
            browserManager = new BrowserManager(selectedAddresses, hostname);
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

    private static class RegistrationManager {

        private final List<JmDNS> publishers = new ArrayList<>();

        public RegistrationManager(List<InetAddress> addresses, String hostname) throws IOException {
            if (addresses == null || addresses.size() == 0) {
                publishers.add(JmDNS.create(null, hostname));
            } else {
                for (InetAddress address : addresses) {
                    publishers.add(JmDNS.create(address, hostname));
                }
            }
        }

        public ServiceInfo register(String type, String domain, String name, int port, JSObject props) throws IOException {
            HashMap<String, String> txtRecord = new HashMap<>();
            if (props != null) {
                Iterator<String> iterator = props.keys();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    txtRecord.put(key, props.getString(key));
                }
            }

            ServiceInfo aService = null;
            for (JmDNS publisher : publishers) {
                ServiceInfo service = ServiceInfo.create(type + domain, name, port, 0, 0, txtRecord);
                try {
                    publisher.registerService(service);
                    aService = service;
                } catch (IOException e) {
                    Log.e(TAG, e.getMessage(), e);
                }
            }
            // returns only one of the ServiceInfo instances!
            return aService;
        }

        public void unregister(String type, String domain, String name) {
            for (JmDNS publisher : publishers) {
                ServiceInfo serviceInfo = publisher.getServiceInfo(type + domain, name, 5000);
                if (serviceInfo != null) {
                    publisher.unregisterService(serviceInfo);
                }
            }
        }

        public void stop() throws IOException {
            for (JmDNS publisher : publishers) {
                publisher.close();
            }
        }
    }

    private class BrowserManager implements ServiceListener {

        private final List<JmDNS> browsers = new ArrayList<>();

        private final Map<String, LabelPrinterServiceWatchCallback> calls = new HashMap<>();

        public BrowserManager(List<InetAddress> addresses, String hostname) throws IOException {
            lock.acquire();

            if (addresses == null || addresses.size() == 0) {
                browsers.add(JmDNS.create(null, hostname));
            } else {
                for (InetAddress address : addresses) {
                    browsers.add(JmDNS.create(address, hostname));
                }
            }
        }

        private void watch(String type, String domain, LabelPrinterServiceWatchCallback callback) {
            calls.put(type + domain, callback);

            for (JmDNS browser : browsers) {
                browser.addServiceListener(type + domain, this);
            }
        }

        private void unwatch(String type, String domain) {
            calls.remove(type + domain);

            for (JmDNS browser : browsers) {
                browser.removeServiceListener(type + domain, this);
            }
        }

        private void close() throws IOException {
            lock.release();

            calls.clear();

            for (JmDNS browser : browsers) {
                browser.close();
            }
        }

        @Override
        public void serviceResolved(ServiceEvent ev) {
            Log.d(TAG, "Resolved");

            sendCallback(LabelPrinterServiceWatchCallback.RESOLVED, ev.getInfo());
        }

        @Override
        public void serviceRemoved(ServiceEvent ev) {
            Log.d(TAG, "Removed");

            sendCallback(LabelPrinterServiceWatchCallback.REMOVED, ev.getInfo());
        }

        @Override
        public void serviceAdded(ServiceEvent ev) {
            Log.d(TAG, "Added");

            sendCallback(LabelPrinterServiceWatchCallback.ADDED, ev.getInfo());
        }

        public void sendCallback(String action, ServiceInfo service) {
            LabelPrinterServiceWatchCallback callback = calls.get(service.getType());
            if (callback == null) {
                return;
            }
            callback.serviceBrowserEvent(action, service);
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