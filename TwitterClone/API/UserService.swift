//
//  UserService.swift
//  TwitterClone
//
//  Created by Fenominall on 12/16/21.
//

import Firebase
import UIKit

// MARK: - Service to fetch user data
struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        // Getting users` references to find to current user`s uid
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Make API call to get user data by uid
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapShoot in
            
            // Cast received from snapshoot(uid) information to convert it into dictionary format,
            // to construct a UserModel
            guard let userDataDictionary = snapShoot.value as? [String: AnyObject] else { return }
            
            // Creating custom user object
            let user = User(uid: uid, dictionary: userDataDictionary)
            completion(user)
        }
    }
}

