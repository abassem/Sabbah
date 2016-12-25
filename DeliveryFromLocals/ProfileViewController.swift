//
//  ProfileViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var uid: String?
    var name: String?
    var email: String?
    var photoURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
        
    
        }
    func getUserInfo(){
        let handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            
            let user = FIRAuth.auth()?.currentUser
            self.email = user?.email
            self.uid = user?.uid
            self.photoURL = user?.photoURL
            
            
            print(user,self.email,self.uid,self.photoURL)
    }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
}
