package com.digasystems.capacitorlabelprinter;

import javax.jmdns.ServiceInfo;

public interface LabelPrinterServiceWatchCallback {
    String ADDED = "added";
    String REMOVED = "removed";
    String RESOLVED = "resolved";

    void serviceBrowserEvent(String action, ServiceInfo service);
}
