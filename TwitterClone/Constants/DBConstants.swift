//
//  DBConstants.swift
//  TwitterClone
//
//  Created by Fenominall on 12/11/21.
//

import Foundation
import Firebase

// Firebase access to database
let DB_REF = Database.database().reference()

// Creating a new structure for users
let REF_USERS = DB_REF.child("users")
// Creating a new structure for tweets
let REF_TWEETS = DB_REF.child("tweets")
// Creating a new structure for user-tweets
let REF_USER_TWEETS = DB_REF.child("user-tweets")

// Creating storage reference for images
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

