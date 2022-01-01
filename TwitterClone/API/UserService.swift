//
//  UserService.swift
//  TwitterClone
//
//  Created by Fenominall on 12/16/21.
//

import Firebase
import UIKit

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

// MARK: - Service to fetch user data
struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        // Getting users` references to find to current user`s uid
        // guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        // storing new users in the users array
        var users: [User] = []
        // Accessing users structure in database to get stored data
        REF_USERS.observe(.childAdded) { snapshot in
            // taking a user key
            let uid = snapshot.key
            // constructing a structure for a new user to be stored it as a dictionary
            guard let userDataDictionary = snapshot.value as? [String: AnyObject] else { return }
            // creating new user by provided data from "userDataDictionary"
            let user = User(uid: uid, dictionary: userDataDictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping (DatabaseCompletion)) {
        // getting a currentUser logged in user uid
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // updating "user-following" database structure,
        // currentUser starts following selected user uid
        // selected uid is added to currentUser following list
        REF_USER_FOLLOWING.child(currentUid)
            .updateChildValues([uid: 1]) { (error, reference) in
                // updating "user-followers" database structure,
                // selected user uid gains "currentUser" uid
                // currentUser uid is added to selected user uid following list
                REF_USER_FOLLOWERS.child(uid)
                    .updateChildValues([currentUid: 1],
                                       withCompletionBlock: completion)
            }
    }
    
    func unfollowUser(uid: String, completion: @escaping (DatabaseCompletion)) {
        // getting a currentUser logged in user uid
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // updating currentUser "user-following" database structure,
        // currentUser is removed from the selected user uid "user-followers" structure
        REF_USER_FOLLOWING.child(currentUid)
            .child(uid).removeValue { (error, reference) in
                // updating selected user uid "user-followers" database structure,
                // selected user uid is removed from the currentUser "user-following" structure
                REF_USER_FOLLOWERS.child(uid)
                    .child(currentUid)
                    .removeValue(completionBlock: completion)
            }
    }
    
    func checkIfUserIsFollowing(uid: String, completion: @escaping (Bool) -> Void) {
        // getting a currentUser logged in user uid
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // Check if selected user uid is already added to currentUser uid "user-following" structure
        REF_USER_FOLLOWING.child(currentUid)
            .child(uid)
            .observeSingleEvent(of: .value) { snapshot in
                completion(snapshot.exists())
            }
    }
    
    /// Function that displays the count of followers and following for each user
    func fetchUserStats(uid: String, completion: @escaping (UserRelationStats) -> Void) {
        // Accessing "user-followers" structure on the database
        // by provided uid to count all followers of the selected uid
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            // Accessing "user-following" structure on the database
            // by provided uid to count all followers of the selected uid
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                // Creating UserRelationStats structure
                // to store "followers" and "following" stats as Int
                let userStats = UserRelationStats(followers: followers, following: following)
                completion(userStats)
            }
        }
    }
    
}

