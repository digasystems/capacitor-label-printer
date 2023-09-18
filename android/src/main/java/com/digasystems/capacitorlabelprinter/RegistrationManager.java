package com.digasystems.capacitorlabelprinter;

import android.util.Log;

import com.getcapacitor.JSObject;

import java.io.IOException;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.jmdns.JmDNS;
import javax.jmdns.ServiceInfo;

public class RegistrationManager {
    private static final String TAG = "RegistrationManager";
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

    public ServiceInfo register(String type, String domain, String name, int port, JSObject props) {
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
