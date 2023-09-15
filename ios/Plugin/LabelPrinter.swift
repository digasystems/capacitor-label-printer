import Foundation
import BRLMPrinterKit

@objc public enum LabelPrinterPublisherAction: Int {
    case added
    case removed
    case resolved
    case error
}

@objc public class LabelPrinter: NSObject {
    fileprivate var publishers: [String: Publisher] = [:]
    fileprivate var browsers: [String: Browser] = [:]

    @objc public func printImage(image: String, ip: String) -> Void {
        let channel = BRLMChannel(wifiIPAddress: "IP address")
        let generateResult = BRLMPrinterDriverGenerator.open(channel)

        // image is base64

        let printSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_820NWB)
        printSettings.labelSize = .dieCutW17H54
        let printError = printerDriver.printImage(with: url, settings: printSettings)

    }

    @objc public func getHostname() -> String {
        let capacity = 128
        let hostname = UnsafeMutablePointer<CChar>.allocate(capacity: capacity)
        gethostname(hostname, capacity)
        #if DEBUG
        print("LabelPrinter: hostname \(hostname)")
        #endif

        #if DEBUG
        print("LabelPrinter: hostname \(hostname)")
        #endif

        return String(cString: hostname)
    }

    @objc public func registerService(type: String, domain: String, name: String, port: Int, props: [String: String], addressFamily: String, callback: @escaping (Bool, [String: NSNumber]?) -> Void) {
        #if DEBUG
        print("LabelPrinter: register \(name + "." + type + domain)")
        #endif

        var txtRecord: [String: Data]?
        txtRecord = [:]
        for (key, value) in props {
            txtRecord?[key] = value.data(using: String.Encoding.utf8)
        }
        let publisher = Publisher(withDomain: domain, withType: type, withName: name, withPort: port, withTxtRecord: txtRecord)
        publishers[name + "." + type + domain] = publisher
        publisher.register(callback)
    }

    @objc public func unregisterService(type: String, domain: String, name: String, callback: @escaping (Bool) -> Void) {
        #if DEBUG
        print("LabelPrinter: unregister \(name + "." + type + domain)")
        #endif

        if let publisher = publishers[name + "." + type + domain] {
            publisher.unregister(callback)
            publishers.removeValue(forKey: name + "." + type + domain)
        } else {
            callback(true)
        }
    }

    @objc public func stop() {
        #if DEBUG
        print("LabelPrinter: stop")
        #endif

        for (_, publisher) in publishers {
            publisher.unregister(nil)
        }
        publishers.removeAll()
    }

    @objc public func watch(type: String, domain: String, callback: @escaping (LabelPrinterPublisherAction, NetService?, [String: NSNumber]?) -> Void) {
        #if DEBUG
        print("LabelPrinter: watch \(type + domain)")
        #endif
        let browser = Browser(withDomain: domain, withType: type)
        browsers[type + domain] = browser
        browser.watch(callback)
    }

    @objc public func unwatch(type: String, domain: String, callback: @escaping (NetService?) -> Void) {
        #if DEBUG
        print("LabelPrinter: unwatch \(type + domain)")
        #endif

        if let browser = browsers[type + domain] {
            browsers.removeValue(forKey: type + domain)
            browser.unwatch(callback)
        } else {
            callback(nil)
        }
    }

    @objc public func close() {
        for (_, browser) in browsers {
            browser.unwatch(nil)
        }
        browsers.removeAll()
    }

    internal class Publisher: NSObject, NetServiceDelegate {

        var nsp: NetService?
        var domain: String
        var type: String
        var name: String
        var port: Int
        var txtRecord: [String: Data]?
        var registerCallback: ((Bool, [String: NSNumber]?) -> Void)?
        var unregisterCallback: ((Bool) -> Void)?

        init (withDomain domain: String, withType type: String, withName name: String, withPort port: Int, withTxtRecord txtRecord: [String: Data]?) {
            self.domain = domain
            self.type = type
            self.name = name
            self.port = port
            self.txtRecord = txtRecord
        }

        func register(_ registerCallback: @escaping (Bool, [String: NSNumber]?) -> Void) {
            self.registerCallback = registerCallback

            // Netservice
            let service = NetService(domain: domain, type: type, name: name, port: Int32(port))
            nsp = service
            service.delegate = self

            if let record = txtRecord {
                if record.count > 0 {
                    service.setTXTRecord(NetService.data(fromTXTRecord: record))
                }
            }

            service.publish()

        }

        func unregister(_ unregisterCallback: ((Bool) -> Void)?) {
            self.unregisterCallback = unregisterCallback
            if let service = nsp {
                service.stop()
            }

        }

        func destroy() {

            if let service = nsp {
                service.stop()
            }

        }

        @objc func netServiceDidPublish(_ netService: NetService) {
            #if DEBUG
            print("LabelPrinter: netService:didPublish:\(netService)")
            #endif

            registerCallback?(true, nil)
        }

        @objc func netService(_ netService: NetService, didNotPublish errorDict: [String: NSNumber]) {
            #if DEBUG
            print("LabelPrinter: netService:didNotPublish:\(netService) \(errorDict)")
            #endif

            registerCallback?(false, errorDict)
        }

        @objc func netServiceDidStop(_ netService: NetService) {
            nsp = nil

            unregisterCallback?(true)
        }

    }

    internal class Browser: NSObject, NetServiceDelegate, NetServiceBrowserDelegate {

        var nsb: NetServiceBrowser?
        var domain: String
        var type: String
        var services: [String: NetService] = [:]
        var watchCallback: ((LabelPrinterPublisherAction, NetService?, [String: NSNumber]?) -> Void)?
        var unwatchCallback: ((NetService) -> Void)?

        init (withDomain domain: String, withType type: String) {
            self.domain = domain
            self.type = type
        }

        func watch(_ watchCallback: @escaping (LabelPrinterPublisherAction, NetService?, [String: NSNumber]?) -> Void) {
            self.watchCallback = watchCallback

            // Net service browser
            let browser = NetServiceBrowser()
            nsb = browser
            browser.delegate = self

            browser.searchForServices(ofType: self.type, inDomain: self.domain)
        }

        func unwatch(_ unwatchCallback: ((NetService) -> Void)?) {
            self.unwatchCallback = unwatchCallback

            if let service = nsb {
                service.stop()
            }

        }

        func destroy() {

            if let service = nsb {
                service.stop()
            }

        }

        @objc func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String: NSNumber]) {
            #if DEBUG
            print("LabelPrinter: netServiceBrowser:didNotSearch: \(errorDict)")
            #endif

            watchCallback?(.error, nil, errorDict)
        }

        @objc func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser,
                                     didFind netService: NetService,
                                     moreComing moreServicesComing: Bool) {
            #if DEBUG
            print("LabelPrinter: netServiceBrowser:didFindService:\(netService)")
            #endif
            netService.delegate = self
            netService.resolve(withTimeout: 5000)
            services[netService.name] = netService // keep strong reference to catch didResolveAddress
            watchCallback?(.added, netService, nil)
        }

        @objc func netServiceDidResolveAddress(_ netService: NetService) {
            #if DEBUG
            print("LabelPrinter: netService:didResolveAddress:\(netService)")
            #endif

            watchCallback?(.resolved, netService, nil)
        }

        @objc func netService(_ netService: NetService, didNotResolve errorDict: [String: NSNumber]) {
            #if DEBUG
            print("LabelPrinter: netService:didNotResolve:\(netService) \(errorDict)")
            #endif

            watchCallback?(.error, netService, errorDict)
        }

        @objc func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser,
                                     didRemove netService: NetService,
                                     moreComing moreServicesComing: Bool) {
            #if DEBUG
            print("LabelPrinter: netServiceBrowser:didRemoveService:\(netService)")
            #endif
            services.removeValue(forKey: netService.name)
            watchCallback?(.removed, netService, nil)
        }

        @objc func netServiceDidStop(_ netService: NetService) {
            nsb = nil
            services.removeAll()
            unwatchCallback?(netService)
        }

    }
}
