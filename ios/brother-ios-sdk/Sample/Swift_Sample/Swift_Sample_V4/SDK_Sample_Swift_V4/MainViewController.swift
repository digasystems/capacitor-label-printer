//
//  MainViewController.swift
//  SwiftSampe_V4
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

import UIKit
import BRLMPrinterKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    //Exapmle of QL-820NWB
    @IBAction func Print(_ sender: Any) {
        //Input your printer's IP address
        let channel = BRLMChannel(wifiIPAddress: "IP address")
        //Input your printer's Bluetooth Serial Number
        //let channel = BRLMChannel(bluetoothSerialNumber: "Bluetooth Serial Number")
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
              let printerDriver = generateResult.driver else {
                  alert(title: "Error", message: "Open Channel: \(generateResult.error.code.rawValue)")
                  return
              }
        defer {
            printerDriver.closeChannel()
        }

        guard
            let url = Bundle.main.url(forResource: "Sample", withExtension: "png")
        else {
            alert(title: "Error", message: "Image file is not found.")
            return
        }

        guard
            //Change here for your printer
            let printSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_820NWB)
        else {
            alert(title: "Error", message: "Fail to create setting.")
          return
        }
        //Change here for your printer label
        printSettings.labelSize = .dieCutW17H54
        let printError = printerDriver.printImage(with: url, settings: printSettings)

        if printError.code != .noError {
            alert(title: "Error", message: "Print Image: \(String(describing: printError.code.rawValue))")
        }
        else {
            alert(title: "Success", message: "Print Image")
        }
    }
    
    func alert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}

