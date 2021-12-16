//
//  User.swift
//  TwitterClone
//
//  Created by Fenominall on 12/16/21.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    let username: String
    let profileImageUrl: String
    let uid: String
    
    // Custom initializer
    // uid - unique identifier
    // The dictionary is user to set all user properties
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
