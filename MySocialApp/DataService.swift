//
//  DataService.swift
//  MySocialApp
//
//  Created by Apostolos Chalkias on 06/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper


//Get the firebase database reference url
let DB_BASE = Database.database().reference()

//Get the firebase storage reference url
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    //Create a single instance of the class
    static let ds = DataService()
    
    ///DB REFERENCES
    //Refernce url
    private var _REF_BASE = DB_BASE
    
    //Posts reference
    private var _REF_POSTS = DB_BASE.child("posts")
    
    //Users reference
    private var _REF_USERS = DB_BASE.child("users")
    
    ///STORAGE REFERENCES
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    //Getters
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference{
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: DatabaseReference{
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES: StorageReference{
        return _REF_POST_IMAGES
    }
    
    
    func createFirebaseDBUser(uid: String,userData: Dictionary<String,String>) {
        //Create a user. Using user unique id. If the object dont exists it will be created.
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
    
    
    
    
    
    
    
}
