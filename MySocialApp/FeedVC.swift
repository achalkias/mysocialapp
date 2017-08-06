//
//  FeedVC.swift
//  MySocialApp
//
//  Created by Apostolos Chalkias on 06/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        
        //Remove the uid from keychain
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        //Sign Out from firebase
        try! Auth.auth().signOut()
        
        //Go back to sign in 
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
}
