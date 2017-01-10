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
import GoogleSignIn
import Fabric
import TwitterKit
import SwiftKeychainWrapper

class SignInVC: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
    
    @IBAction func twitterBtnTapped(_ sender: Any) {
        Twitter.sharedInstance().logIn() { (result, error) in
            if error != nil {
                print ("Unable to authenticate with Twitter - \(error?.localizedDescription)")
            } else {
                print ("User authenticated with Twitter")
                let credentials = FIRTwitterAuthProvider.credential(withToken: (result?.authToken)!, secret: (result?.authTokenSecret)!)
                self.fireBaseAuth(credentials)
            }
        }
        
    }
    
    @IBAction func googleBtnTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if error != nil {
            print("Unable to authenticate with Google - \(error?.localizedDescription)")
        } else {
            print("User authenticated with Google")
            let authentication = user.authentication
            let credentials = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
            self.fireBaseAuth(credentials)
            if let user = user {
                let userData = ["provider": "Google"]
                self.completeSignIn(id: user.userID, userData: userData)
            }
        }
    }
    
    @IBAction func signinBtnTapped(_ sender: Any) {
        if let email = emailField.text, let psw = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: psw, completion: { (user, error) in
                if error == nil {
                    print("User autheticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: psw, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with firebase using email - \(error)")
                        } else {
                            print("Succesfully authenticated with firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
                
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}

