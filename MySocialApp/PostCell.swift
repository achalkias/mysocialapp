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
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        
    }

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
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
        
    }


}
