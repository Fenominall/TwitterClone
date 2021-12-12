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
let REF_USERS = DB_REF.child("users")

// Creating storage reference for images
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
