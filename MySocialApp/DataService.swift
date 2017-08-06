//
//  DataService.swift
//  MySocialApp
//
//  Created by Apostolos Chalkias on 06/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import Foundation
import Firebase


//Get the firebase database reference url
let DB_BASE = Database.database().reference()

class DataService {

    //Create a single instance of the class
    static let ds = DataService()
    
    //Refernce url
    private var _REF_BASE = DB_BASE
    
    //Posts reference
    private var _REF_POSTS = DB_BASE.child("posts")
    
    //Users reference
    private var _REF_USERS = DB_BASE.child("users")
    
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
    
    func createFirebaseDBUser(uid: String,userData: Dictionary<String,String>) {
        //Create a user. Using user unique id. If the object dont exists it will be created.
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
    
    
    
    
    
    

}
