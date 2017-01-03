//
//  SignInVC.swift
//  sWimmieSocial
//
//  Created by Wim van Deursen on 02-01-17.
//  Copyright © 2017 sWimmie. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenthicate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("User cancelled Facebook authentication")
            } else {
                print("User authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseAuth(credential)
                
            }
        }
    }
    
    @IBAction func signinBtnTapped(_ sender: Any) {
        if let email = emailField.text, let psw = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: psw, completion: { (user, error) in
                if error == nil {
                    print("User autheticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: psw, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with firebase using email - \(error)")
                        } else {
                            print("Succesfully authenticated with firebase")
                        }
                    })
                }
            })
        }
        
    }
    
    
    func fireBaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase - \(error)")
            } else {
                print("Succesfully authenticated with Firebase")
            }
        })
    }

}

