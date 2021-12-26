//
//  User.swift
//  TwitterClone
//
//  Created by Fenominall on 12/16/21.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    
    // Checking if the user is the current user
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    // Custom initializer
    // uid - unique identifier
    // The dictionary is user to set all user properties
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
      
    }
}
