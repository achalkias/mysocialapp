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
    
    // MARK: Variables
    //----------------
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        //Get database refernce
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            //Get the data from firebase and pass them to objects
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.posts = []
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    //Store data
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        //Add post to array
                        self.posts.append(post)
                        
                    }
                }
                //Reload tableview data
                self.tableView.reloadData()
                
            }
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create an object of type post
        let post = posts[indexPath.row]
        
        //Pass the object as cell item
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
        
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
