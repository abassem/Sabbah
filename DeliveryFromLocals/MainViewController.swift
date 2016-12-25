//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import MessageUI
import RevealingSplashView
import SwiftyJSON

class MainViewController: UIViewController, MFMessageComposeViewControllerDelegate {
var json:JSON = [:]
    @IBOutlet weak var tableView: UITableView!
    
    var mainContens = ["MAsr EL Kheir", "Food Bank", "magdi Yaacoub", "Resala", "Nahr El Kheir", "Satr we Ghata", "Sona'a el Hayah", "Bank EL Shefa'a", "Ma'ahad El Awram", "500-500 Hospital", "lagnet el Eghata we Altaware2 (Palastine,Syria & Somalia", "bena2 we ta3meer masaged"]
    var mainNumbers = ["9597", "9595", "9698", "9598", "95535", "95530", "9695", "9699", "95300", "9797", "9596", "95230"]
    var cities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerCellNib(DataTableViewCell.self)
        
        
        self.view.backgroundColor = backgroundColor
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "wallpaper.jpg")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor.white)
        
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        
        
        //Adds the revealing splash view as a sub view
        let window = UIApplication.shared.keyWindow
        window?.addSubview(revealingSplashView)
        
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
            
   
            //json
            if let path = Bundle.main.path(forResource: "text", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    self.json = JSON(data: data)
                    if self.json != JSON.null {
                        let list:Array<JSON> = self.json["studios"].array!;
                        self.cities = list.map {
                            (item) -> String in
                            return item["name"].stringValue;
                        }
                        
                    } else {
                        print("Could not get json from file, make sure that file contains valid json.")
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                print("Invalid filename/path.")
            }
            
            
            
        }

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension MainViewController : UITableViewDelegate {
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

extension MainViewController : UITableViewDataSource {
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
            controller.body = " "
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        
    }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: "You've just helped someone", message: "Thank you :)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Awesome !", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //EZLoadingActivity.hide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let cell = sender as? UITableViewCell {
//            let i = tableView.indexPath(for: cell)?.row;
//            if segue.identifier == "ShowFilms" {
//                if let vc = segue.destination as? SubContentsViewController {
//                    vc.nname = i
//                    vc.json = json["studios"][i!]
//                    vc.title = json["studios"][i!]["name"].stringValue
//                }
//            }
//        }
//    }
    
}
