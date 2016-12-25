//
//  LoginViewController.swift
//  DeliveryFromLocals
//
//  Created by Abdo Assem on 12/22/16.

//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    
    var uid = String()
    var tokenString = String()
    var email = String()
    var displayName = String()

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        
        // Optional: Place the button in the center of your view.
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.checkFacebookLoginStatus()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.checkFacebookLoginStatus()
    }
    func checkFacebookLoginStatus(){
        if  (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print(" Already Logged-in by Facebook")
            self.createMenuView()
            self.performSegue(withIdentifier: "toMain", sender: self)
        }else{
            //Login Failed
        }
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did log out")
    }
    open func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print("logged in to Facebook")
        self.createMenuView()
        performSegue(withIdentifier: "toMain", sender: self)
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            self.uid = (user?.uid)!
            self.tokenString = FBSDKAccessToken.current().tokenString
            self.email = (user?.email)!
            self.displayName = (user?.displayName)!
            
            // self.photoURL = (user?.photoURL)! as NSURL
           
            let userRef = DataService.dataService.USER_REF.child(self.uid)
            
            userRef.child("token").setValue(self.tokenString)
            userRef.child("email").setValue(self.email)
            userRef.child("displayName").setValue(self.displayName)
            //userRef.child("photoURL").setValue(self.photoURL)
            
            self.checkUserDefaults()
            
            if let error = error {
                // ...
                return
            }
        }
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toMain" {
                if let viewController = segue.destination as? MainViewController {
                    print("segued")
                    //viewController.property = property
                }
        }
        }
    }
    
    
    func checkUserDefaults(){
        
        if UserDefaults.standard.object(forKey: "uid") == nil {
            UserDefaults.standard.set(self.uid, forKey: "uid")
								}
								UserDefaults.standard.set(self.tokenString, forKey: "accessToken")
        UserDefaults.standard.set(self.email, forKey: "email")
								
    }

    open func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = backgroundColor
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        appDelegate.window?.rootViewController = slideMenuController
        appDelegate.window?.makeKeyAndVisible()
    }
}
