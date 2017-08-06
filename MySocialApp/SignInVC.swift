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

class SignInVC: UIViewController {

    
    // MARK: VARIABLES
    //----------------
    
    var TAG:String = "SignInVC"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
                
            } else if result?.isCancelled == true{
               
                //There is no error but still the user can cancel the perimssion request
                print("\(self.TAG) Facebook Error: User canceled Facebook Authentication.")
                
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
                print("\(self.TAG) Facebook Success: User Successfully authnticated with firebase")
            }
        }
    
    }
    
    
    
    
    
    
    
    // MARK: IBActions
    //----------------
    @IBAction func facebookBtnTapped(_ sender: UIButton) {
        //Try to login via facebook
        fbLogin()
    }
    

}

