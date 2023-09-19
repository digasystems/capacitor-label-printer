import Foundation
import BRLMPrinterKit

@objc public enum LabelPrinterPublisherAction: Int {
    case added
    case removed
    case resolved
    case error
}

@objc public class LabelPrinter: NSObject {
    fileprivate var browsers: [String: Browser] = [:]

    @objc public func printImage(image: String, ip: String, printer: String, label: String) -> Void {
        let channel = BRLMChannel(wifiIPAddress: "IP address")
        let generateResult = BRLMPrinterDriverGenerator.open(channel)

        // image is base64

        let printSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_820NWB) // printer
        printSettings.labelSize = .dieCutW17H54 // label
        let printError = printerDriver.printImage(with: url, settings: printSettings)

        if printError.code != .noError {
            alert(title: "Error", message: "Print Image: \(String(describing: printError.code.rawValue))")
        }
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
