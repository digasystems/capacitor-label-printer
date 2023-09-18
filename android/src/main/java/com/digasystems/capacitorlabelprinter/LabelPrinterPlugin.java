
package com.digasystems.capacitorlabelprinter;

import android.Manifest;
import android.content.Context;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import java.io.IOException;
import java.net.InetAddress;
import java.util.Enumeration;
import javax.jmdns.ServiceInfo;

@CapacitorPlugin(
    name = "LabelPrinter",
    permissions = {
        @Permission(
            strings = {
                Manifest.permission.ACCESS_WIFI_STATE, Manifest.permission.CHANGE_WIFI_MULTICAST_STATE, Manifest.permission.INTERNET
            },
            alias = "internet"
        )
    }
)
public class LabelPrinterPlugin extends Plugin {

    private static final String TAG = "LabelPrinter";

    private final LabelPrinter implementation = new LabelPrinter();

    @Override
    public void load() {
        implementation.initialize(getActivity());
    }

    @PluginMethod
    public void getHostname(PluginCall call) {
        String hostname = implementation.getHostname();
        if (hostname != null) {
            JSObject result = new JSObject();
            result.put("hostname", hostname);
            call.resolve(result);
        } else {
            call.reject("Error: undefined hostname");
        }
    }

    @PluginMethod
    public void printImage(PluginCall call) {
        final String image = call.getString("image");
        final String ip = call.getString("ip");
        final String printer = call.getString("printer");
        final String label = call.getString("label");

        implementation.printImage(image, ip, printer, label);
        call.resolve();
    }

    @PluginMethod
    public void register(PluginCall call) {
        final String type = call.getString("type");
        final String domain = call.getString("domain");
        final String name = call.getString("name");
        final int port = call.getInt("port");
        final JSObject props = call.getObject("props");
        final String addressFamily = call.getString("addressFamily");

        getBridge()
            .executeOnMainThread(() -> {
                try {
                    ServiceInfo service = implementation.registerService(type, domain, name, port, props, addressFamily);
                    JSObject status = new JSObject();
                    status.put("action", "registered");
                    status.put("service", jsonifyService(service));

                    call.resolve(status);
                } catch (IOException | RuntimeException e) {
                    call.reject(e.getMessage());
                }
            });
    }

    @PluginMethod
    public void unregister(PluginCall call) {
        final String type = call.getString("type");
        final String domain = call.getString("domain");
        final String name = call.getString("name");

        getBridge()
            .executeOnMainThread(() -> {
                implementation.unregisterService(type, domain, name);
                call.resolve();
            });
    }

    @PluginMethod
    public void stop(PluginCall call) {
        getBridge()
            .executeOnMainThread(() -> {
                try {
                    implementation.stop();
                } catch (IOException e) {
                    call.reject("Error: " + e.getMessage());
                }
            });
    }

    @PluginMethod(returnType = PluginMethod.RETURN_CALLBACK)
    public void watch(PluginCall call) {
        final String type = call.getString("type");
        final String domain = call.getString("domain");
        final String addressFamily = call.getString("addressFamily");

        getBridge()
            .executeOnMainThread(() -> {
                try {
                    implementation.watchService(
                        type,
                        domain,
                        addressFamily,
                        (action, service) -> {
                            JSObject status = new JSObject();
                            status.put("action", action);
                            status.put("service", jsonifyService(service));

                            call.setKeepAlive(true);
                            call.resolve(status);
                        }
                    );
                } catch (IOException | RuntimeException e) {
                    call.reject("Error: " + e.getMessage());
                }
            });

        call.setKeepAlive(true);
        call.resolve();
    }

    @PluginMethod
    public void unwatch(PluginCall call) {
        final String type = call.getString("type");
        final String domain = call.getString("domain");

        getBridge()
            .executeOnMainThread(() -> {
                implementation.unwatchService(type, domain);
                call.resolve();
            });
    }

    @PluginMethod
    public void close(PluginCall call) {
        getBridge()
            .executeOnMainThread(() -> {
                try {
                    implementation.close();
                    call.resolve();
                } catch (IOException e) {
                    call.reject("Error: " + e.getMessage());
                }
            });
    }

    private static JSObject jsonifyService(ServiceInfo service) {
        JSObject obj = new JSObject();

        String domain = service.getDomain() + ".";
        obj.put("domain", domain);
        obj.put("type", service.getType().replace(domain, ""));
        obj.put("name", service.getName());
        obj.put("port", service.getPort());
        obj.put("hostname", service.getServer());

        JSArray ipv4Addresses = new JSArray();
        InetAddress[] inet4Addresses = service.getInet4Addresses();
        for (InetAddress inet4Address : inet4Addresses) {
            if (inet4Address != null) {
                ipv4Addresses.put(inet4Address.getHostAddress());
            }
        }
        obj.put("ipv4Addresses", ipv4Addresses);

        JSArray ipv6Addresses = new JSArray();
        InetAddress[] inet6Addresses = service.getInet6Addresses();
        for (InetAddress inet6Address : inet6Addresses) {
            if (inet6Address != null) {
                ipv6Addresses.put(inet6Address.getHostAddress());
            }
        }
        obj.put("ipv6Addresses", ipv6Addresses);

        JSObject props = new JSObject();
        Enumeration<String> names = service.getPropertyNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            props.put(name, service.getPropertyString(name));
        }
        obj.put("txtRecord", props);

        return obj;
    }
}