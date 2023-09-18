package com.digasystems.capacitorlabelprinter;

import static android.content.Context.WIFI_SERVICE;

import android.app.Activity;
import android.net.wifi.WifiManager;
import android.util.Log;

import java.io.IOException;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jmdns.JmDNS;
import javax.jmdns.ServiceEvent;
import javax.jmdns.ServiceInfo;
import javax.jmdns.ServiceListener;

public class BrowserManager implements ServiceListener {
    WifiManager.MulticastLock lock;
    private static final String TAG = "BrowserManager";


    private final List<JmDNS> browsers = new ArrayList<>();

    private final Map<String, LabelPrinterServiceWatchCallback> calls = new HashMap<>();

    public BrowserManager(Activity activity, List<InetAddress> addresses, String hostname) throws IOException {
        WifiManager wifi = (WifiManager) activity.getApplicationContext().getSystemService(WIFI_SERVICE);
        lock = wifi.createMulticastLock("LabelPrinterPluginLock");
        lock.setReferenceCounted(false);
        lock.acquire();

        if (addresses == null || addresses.size() == 0) {
            browsers.add(JmDNS.create(null, hostname));
        } else {
            for (InetAddress address : addresses) {
                browsers.add(JmDNS.create(address, hostname));
            }
        }
    }

    public void watch(String type, String domain, LabelPrinterServiceWatchCallback callback) {
        calls.put(type + domain, callback);

        for (JmDNS browser : browsers) {
            browser.addServiceListener(type + domain, this);
        }
    }

    public void unwatch(String type, String domain) {
        calls.remove(type + domain);

        for (JmDNS browser : browsers) {
            browser.removeServiceListener(type + domain, this);
        }
    }

    public void close() throws IOException {
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