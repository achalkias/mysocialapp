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

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    // MARK: IBOutlets
    //----------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: FancyField!
    
    
    // MARK: Variables
    //----------------
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<AnyObject, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true //User can edit the image
        
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
            
            if let img = FeedVC.imageCache.object(forKey: post.imgurl as AnyObject) {
               cell.configureCell(post: post,img: img)
            } else {
                cell.configureCell(post: post)
            }
            
            
            return cell
        } else {
            return PostCell()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Get the selected image
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
           imageAdd.image = image
            imageSelected = true
        } else {
            print("IMAGE: A valid image was not selected")
        }
        
        //Close the imagepicker when the user select an image
        imagePicker.dismiss(animated: true, completion: nil)
      
    }
    
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageurl": imgUrl,
            "likes": 0
        ]
        
        //Create a firebase post and set it child id and the value which is the dictionary 'post'
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        //Clear fields and reset image
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
    }
    
    
    // MARK: IBActions
    //----------------

    
    @IBAction func postButtonTapped(_ sender: Any) {
        //Check fields and data that are required to post
        guard let caption = captionField.text, caption != "" else {
            print("POST: Caption must be entered.")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            print("POST: An image must be selected")
            return
        }
        
        //Convert the image to jpeg and compress it
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            //Create a unique identifier and metaData content type
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            //Post image to storage
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData,metadata: metaData) {
                (metaData,error) in
                if error != nil {
                    print("Unable to upload image to firebse storage")
                } else {
                    print("Image successfully uploded to firebase storage")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                    
                }
            }
            
            
            
        }
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        //Open Image Picker View
        present(imagePicker, animated: true, completion: nil)
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
