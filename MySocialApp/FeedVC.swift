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

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK: IBOutlets
    //----------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        //Get database refernce
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print(snapshot.value)
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    

    @IBAction func signOutTapped(_ sender: UIButton) {
        
        //Remove the uid from keychain
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        //Sign Out from firebase
        try! Auth.auth().signOut()
        
        //Go back to sign in 
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
}
