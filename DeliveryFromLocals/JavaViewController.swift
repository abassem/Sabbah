//
//  JavaViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import MessageUI
class JavaViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    
    var mainContens = ["57357", "Abo El Reish", "Tahya Masr", "Magdi Yacoub", "El Orman", "data6", "data7", "data8", "data9", "data10", "data11", "data12", "data13", "data14", "data15"]
    var mainNumbers = ["573571", "573572", "573573", "573574", "573575", "573576", "data7", "data8", "data9", "data10", "data11", "data12", "data13", "data14", "data15"]
    
    var cities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(DataTableViewCell.self)

        
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    
    
}

extension JavaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainContens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
        let data = DataTableViewCellData(imageUrl: "dummy", text: mainContens[indexPath.row])
        cell.setData(data)
        return cell
    }
    
    func sendQuickSms(_ iPath: IndexPath) {
        
        let clicked = self.mainContens[iPath.row]
        let number = self.mainNumbers[iPath.row]
        print(clicked)
        print(number)
        
        let phoneNumber : String = number
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Empty"
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
            
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
        
        //EZLoadingActivity.hide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
extension JavaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        //        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
        //        self.navigationController?.pushViewController(subContentsVC, animated: true)
        
        self.sendQuickSms(indexPath)
    }
}
