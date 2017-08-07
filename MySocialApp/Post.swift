//
//  Post.swift
//  MySocialApp
//
//  Created by Apostolos Chalkias on 07/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import Foundation

class Post {
    
    //Variables
    private var _caption: String!
    private var _imgurl: String!
    private var _likes: Int!
    private var _postKey: String!
    
    //Getters
  
    var caption: String {
        return _caption
    }
 
    var imgurl: String {
        return _imgurl
    }
    
    var likes: Int {
        return _likes
    }

    var postKey: String {
        return _postKey
    }
    
    //Initializers
    init(caption: String,imgurl: String,likes: Int){
        self._caption = caption
        self._imgurl = imgurl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String,AnyObject>){
        self._postKey = postKey
      
        //Get Data from object dictionary
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
     
        if let imgurl = postData["imageurl"] as? String{
            self._imgurl = imgurl
        }
     
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        
    }
    
    
    
}
