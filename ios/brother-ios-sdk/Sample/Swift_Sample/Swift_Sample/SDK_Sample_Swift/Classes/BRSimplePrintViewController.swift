//
//  BRSimplePrintViewController.swift
//  SDK_Sample_Swift
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

import Foundation
import UIKit
import BRLMPrinterKit


class BRSimplePrintViewController: UIViewController, BRSelectDeviceTableViewControllerDelegate {

    var selectedDeviceInfo : BRPtouchDeviceInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Select Device
    @IBAction func selectButtonTouchDown(_ sender: Any) {
        self.performSegue(withIdentifier: "goSelectDeviceSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goSelectDeviceSegue") {
            guard let selectDeviceTableViewController = segue.destination as? BRSelectDeviceTableViewController else {
                print("Prepare for Segue Error")
                return
            }
            selectDeviceTableViewController.delegate = self
        }
    }
    
    func setSelected(deviceInfo: BRPtouchDeviceInfo) {
        selectedDeviceInfo = deviceInfo
    }
    
    // Print
    @IBAction func printButtonTouchDown(_ sender: Any) {
        
        guard let img = UIImage(named: "100×200.bmp") else {return}
        guard let modelName = selectedDeviceInfo?.strModelName else {return}
        let venderName = "Brother "
        let dev = venderName + modelName
        guard let num = selectedDeviceInfo?.strSerialNumber else {return}

        self.printImage(image: img, deviceName: dev, serialNumber: num)
    }
    
    func printImage (image: UIImage, deviceName: String, serialNumber: String) {
        
        guard let ptp = BRPtouchPrinter(printerName: deviceName, interface: CONNECTION_TYPE.BLUETOOTH) else {
            print("*** Prepare Print Error ***")
            return
        }
        ptp.setupForBluetoothDevice(withSerialNumber: serialNumber)
        ptp.setPrintInfo(self.settingPrintInfoForPJ())
                
        if ptp.startCommunication() {
            let result = ptp.print(image.cgImage, copy: 1)
            if result != ERROR_NONE_ {
                print ("*** Printing Error ***")
            }
            ptp.endCommunication()
        }
        else {
            print("Communication Error")
        }
    }
    
    func settingPrintInfoForPJ() -> BRPtouchPrintInfo {
        
        let printInfo = BRPtouchPrintInfo()
        
        printInfo.strPaperName = "A4_CutSheet"
        printInfo.nPrintMode = PRINT_FIT
        printInfo.nExtFlag = EXT_PJ700_FP
        
        return printInfo
    }
    
    func settingPrintInfoForQL() -> BRPtouchPrintInfo {
        
        let printInfo = BRPtouchPrintInfo()
        
        printInfo.strPaperName = "62mm"
        printInfo.nPrintMode = PRINT_FIT
        printInfo.nAutoCutFlag = OPTION_AUTOCUT
        
        return printInfo
    }
    
    func settingPrintInfoForPT() -> BRPtouchPrintInfo {
        
        let printInfo = BRPtouchPrintInfo()
        
        printInfo.strPaperName = "24mm"
        printInfo.nPrintMode = PRINT_FIT
        printInfo.nAutoCutFlag = OPTION_AUTOCUT
        printInfo.bEndcut = true
        
        return printInfo
    }
}
