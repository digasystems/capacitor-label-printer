//
//  BRMainViewController.swift
//  SDK_Sample_Swift
//
//  Copyright © 2017 Brother Industries, Ltd. All rights reserved.
//

import Foundation
import UIKit

enum Category: String {
    case simplePrintBluetooth = "Simple Print (Bluetooth)"
    case customPaperPrintBluetooth = "Custom Paper Print (Bluetooth)"
    
    static let cate = [simplePrintBluetooth, customPaperPrintBluetooth]
}

class BRMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.cate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "main_tableViewCell", for: indexPath)
        cell.textLabel!.text = Category.cate[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Category.cate[indexPath.row] {
        case (Category.simplePrintBluetooth):
            self.presentSimplePrintView()
        case (Category.customPaperPrintBluetooth):
            self.presentCustomPrintView()
        }
    }
    
    func presentSimplePrintView() {
        let simplePrintViewStoryboard = UIStoryboard(name: "BRSimplePrintViewController", bundle: nil)
        let simplePrintViewController = simplePrintViewStoryboard.instantiateViewController(withIdentifier: "BRSimplePrintViewController")
        
        let backButton = UIBarButtonItem(title: "Back",
                                         style: .plain,
                                         target: self,
                                         action: #selector(goMainView))
        simplePrintViewController.navigationItem.leftBarButtonItem = backButton
        
        let nc = UINavigationController(rootViewController: simplePrintViewController)
        
        present(nc, animated: true, completion: nil)
    }
    
    func presentCustomPrintView() {
        print("presentCustomPrintView")
    }
    
    @objc func goMainView () {
        self.dismiss(animated: true, completion: nil)
    }
}
