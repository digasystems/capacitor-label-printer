//
//  BRSelectDeviceTableViewController.swift
//  SDK_Sample_Swift
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

import Foundation
import UIKit
import BRLMPrinterKit


@objc protocol BRSelectDeviceTableViewControllerDelegate : NSObjectProtocol {
    func setSelected(deviceInfo: BRPtouchDeviceInfo)
}

class BRSelectDeviceTableViewController: UITableViewController {
    
    var delegate: BRSelectDeviceTableViewControllerDelegate?
    var deviceListByMfi : [BRPtouchDeviceInfo]?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.BRDeviceDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.BRDeviceDidDisconnect, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BRPtouchBluetoothManager.shared()?.registerForBRDeviceNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidConnect), name: NSNotification.Name.BRDeviceDidConnect , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidDisconnect), name: NSNotification.Name.BRDeviceDidDisconnect, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        deviceListByMfi = BRPtouchBluetoothManager.shared()?.pairedDevices() as? [BRPtouchDeviceInfo] ?? []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func accessoryDidConnect( notification : Notification) {
        if let connectedAccessory = notification.userInfo?[BRDeviceKey] {
            print("ConnectDevice : \(String(describing: (connectedAccessory as? BRPtouchDeviceInfo)?.description()))")
        }

        deviceListByMfi = BRPtouchBluetoothManager.shared()?.pairedDevices() as? [BRPtouchDeviceInfo] ?? []
        
        self.tableView.reloadData()
    }
    
    @objc func accessoryDidDisconnect( notification : Notification) {
        if let disconnectedAccessory = notification.userInfo?[BRDeviceKey] {
            print("DisconnectDevice : \(String(describing: (disconnectedAccessory as? BRPtouchDeviceInfo)?.description()))")
        }

        deviceListByMfi = BRPtouchBluetoothManager.shared()?.pairedDevices()  as? [BRPtouchDeviceInfo] ?? []
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceListByMfi?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "selectDeviceTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)

        cell.textLabel?.text = deviceListByMfi?[indexPath.row].strModelName ?? nil
        cell.detailTextLabel?.text = deviceListByMfi?[indexPath.row].strSerialNumber ?? nil
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let deviceInfo = deviceListByMfi?[indexPath.row] {
            self.delegate?.setSelected(deviceInfo: deviceInfo)
        }
    }
}
