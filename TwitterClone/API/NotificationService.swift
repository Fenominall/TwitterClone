//
//  NotificationService.swift
//  TwitterClone
//
//  Created by Fenominall on 1/9/22.
//

import Foundation
import Firebase


struct NotificationService {
    
    // MARK: - Properties
    static let shared = NotificationService()
    
    private init() {}
    
    
    func uploadNotification(type: NotificationType,
                            tweet: Tweet? = nil,
                            user: User? = nil) {
        // Getting the current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // constructing values into a dictionary
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        // if a tweet was passed, it means that notification is for a tweet
        if let tweet = tweet {
            // TweetID value will be added to "values" dictionary
            values["tweetID"] = tweet.tweetID
            // Accessing "notifications" structure in database and adding new
            // accessing tweet.user.uid because notification will be sent to the user on which tweet a like was added
            REF_NOTIFICATIONS.child(tweet.user.uid)
                // generating new uid for notification structure
                .childByAutoId()
                // updating generated uid with the provided values
                .updateChildValues(values)
        } else if let user = user{
            // if a user is initiated in the notification, then user uid will be added to the notifications list
            REF_NOTIFICATIONS.child(user.uid)
                // new uid will be generated for notification
                .childByAutoId()
                // provided values are being updated to the generated notification structure with the reference to user uid
                .updateChildValues(values)
        }
    }
    
    /// Fetching notifications from the Database
    func fetchNotifications(completion: @escaping ([Notification]) -> ()) {
        
        // temporary container to store received notifications
        var notifications: [Notification] = []
        
        // getting current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // accessing "notifications" structure and all it`s child values in snapshot
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            // creating a dictionary for received values from a snapshot
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            // getting user uid from a notification`s structure
            guard let uid = dictionary["uid"] as? String else { return }
            // Fetching user by uid in notifications structure
            UserService.shared.fetchUser(uid: uid) { user in
                // creating a notification with the received user data and dictionary values to construct a notification
                let notification = Notification(user: user, dictionary: dictionary)
                // adding a notification to notifications array
                notifications.append(notification)
                // passing values to completion block where it`s data can be user later on
                completion(notifications)
            }
            
            
            
        }
        
    }
}
