//
//  AuthService.swift
//  TwitterClone
//
//  Created by Fenominall on 12/12/21.
//

import Foundation
import UIKit
import Firebase


struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let username: String
    let profileImage: UIImage
}

// MARK: - Singleton for registering a user to Firebase
struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        // Login the user with email and password to register account
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> ()) {
        let email = credentials.email
        let password = credentials.password
        let fullName = credentials.fullName
        let username = credentials.username
        
        // Converting an uploaded image into data and
        // compressing an image quality
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        // Generating unique UUID for each uploaded image
        let fileName = NSUUID().uuidString
        // Referencing the place for created storage
        let storageRef = STORAGE_PROFILE_IMAGES.child(fileName)
        
        // Uploading image data to the provided storage reference
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            print("Image data was put to Firebase storage...")
            // Getting downloaded url for an image, storage url is gonna be stored in the database structure
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {
                    print("URL is missing \(String(describing: error))")
                    return }
                // Firebase authentication creating a user
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG THE ERROR: \(error.localizedDescription)")
                        return
                    }
                    // UID asks to come data back for the result in Auth call
                    guard let uid = result?.user.uid else { return }
                    // Dictionary with values to register the user
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullName,
                                  "profileImageUrl": profileImageUrl]
                    
                    // Creating database structure for user profile
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
