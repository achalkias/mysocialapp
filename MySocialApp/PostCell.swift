//
//  PostCell.swift
//  MySocialApp
//
//  Created by Apostolos Chalkias on 06/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!

    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var caption: UITextView!
    
    @IBOutlet weak var likesLbl: UILabel!
    
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    //Get the likes refernce
    var likesRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        //Create a tap gesture recognizer and add it to likeImg
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        
        //Get likes refernce
        likesRef = DataService.ds.REF_POSTS.child("likes").child(post.postKey)
        
        
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        //Set image
        if img != nil {
            //Set image from cache
            self.postImg.image = img
        } else{
            //Download the image from firebase
            let ref = Storage.storage().reference(forURL: post.imgurl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (
                data, error) in
                
                if error != nil {
                    print("IAMGE: Unable to download image from firebase storage")
                } else {
                    print("IMAGE: Image downloaded from firebase storage")
                    
                    //Convert the data to a UIImage
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imgurl as AnyObject)
                        }
                    }
                }
                
                
            })
        }
        
       
        //Create an observer of a single event
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        //Create an observer of a single event
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                //Add a like
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                //Remove a like
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
        
    }


}
