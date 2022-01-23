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
    var fullname: String
    var username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    // It`s options because this properties will be available only after a user is fetched
    var stats: UserRelationStats?
    var bio: String?
    
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
        
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}


struct UserRelationStats {
    var followers: Int
    var following: Int
}
