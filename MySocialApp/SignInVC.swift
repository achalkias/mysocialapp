//
//  ViewController.swift
//  MySocialApp
//
//  Created by Apostolos Chalkias on 05/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    
    // MARK: VARIABLES
    //----------------
    
    var TAG:String = "SignInVC"
    
    
    // MARK: IBOutlets
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Check if the key exists and perform a segue
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    
    
    // MARK: Custom Functions
    //-----------------------
    
    
    
    func fbLogin() {
        
        //Init login manager
        let facebookLogin = FBSDKLoginManager()
        
        //Ask perimsisions and start login process
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (
            result, error) in
            
            //Check for error
            if error != nil {
                
                //Something is wrong print the error
                print("\(self.TAG) Facebook Error: \(error.debugDescription)")
                
                self.showAlert(title: "Facebook", message: "Unable to sign in with Facebook")
                
            } else if result?.isCancelled == true{
                
                //There is no error but still the user can cancel the perimssion request
                print("\(self.TAG) Facebook Error: User canceled Facebook Authentication.")
                
                self.showAlert(title: "Facebook", message: "Unable to sign in with Facebook")
                
            }else {
                
                //User Successfully authnticated with facebook
                print("\(self.TAG) Facebook Success: User Successfully authnticated with facebook")
                
                //Get the credential and authenticate with firebase using facebok access token
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                //Try to authenticate with firebase
                self.firebaseAuth(credential)
                
                
                
            }
            
        }
        
    }
    
    
    
    
    
    /// Authencticate with firebase. Pass the credentials
    ///
    /// - Parameter credential: The credential token.
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (
            user, error) in
            if error != nil {
                //Something is wrong print the error
                print("\(self.TAG) Firebase Error: \(error.debugDescription)")
            } else {
                //User Successfully authnticated with firebase
                print("\(self.TAG) Firebase Success: User Successfully authnticated with firebase")
                
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
                
            }
        }
        
    }
    
    
    func completeSignIn(id: String){
        //Save the key so the user will not have to sign in every time
        let keychainResutl = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("\(self.TAG) Keychain Success: Data saved to keychain \(keychainResutl))")
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
    
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    
    
    
    // MARK: IBActions
    //----------------
    @IBAction func facebookBtnTapped(_ sender: UIButton) {
        //Try to login via facebook
        fbLogin()
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        
        //Check Email and password fields are not empty
        if let email = emailField.text, let pwd = pwdField.text {
            
            if pwd.characters.count < 6 {
                showAlert(title: "SIGN IN", message: "Password must be at least 6 characters")
            }
            
            //Try to authorize with firebase
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (
                user, error) in
                
                if error == nil {
                    //User already exists
                    //User Successfully authnticated with firebase
                    print("\(self.TAG) Email User Success: User Successfully authnticated with firebase")
                    
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                } else {
                    //User does not exists
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (
                        user, error) in
                        if error != nil {
                            //Something is wrong
                            print("\(self.TAG) Email User Success: User Unable to created with firebase")
                            
                            self.showAlert(title: "SIGN IN", message: "Unable to create user.")
                            
                        } else{
                            //User created
                            print("\(self.TAG) Email User Success: User Successfully created with firebase")
                            
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
                
            })
            
            
        } else{
            showAlert(title: "SIGN IN", message: "Empty email or password.")
        }
        
        
    }
    
    
    
}

