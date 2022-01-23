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
    
    func uploadNotification(toUser user: User,
                            type: NotificationType,
                            tweetID: String? = nil) {
        // Getting the current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // constructing values into a dictionary
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        // if a tweet was passed, it means that notification is for a tweet
        if let tweetID = tweetID {
            // TweetID value will be added to "values" dictionary
            values["tweetID"] = tweetID
        }
        // Accessing "notifications" structure in database and adding new
        // accessing tweet.user.uid because notification will be sent to the user on which tweet a like was added
        // if a user is initiated in the notification, then user uid will be added to the notifications list
        REF_NOTIFICATIONS.child(user.uid)
        // new uid will be generated for notification
            .childByAutoId()
        // provided values are being updated to the generated notification structure with the reference to user uid
            .updateChildValues(values)
    }
    
    fileprivate func getUserNotification(uid: String, completion: @escaping ([Notification]) -> ()) {
        var notifications = [Notification]()
        // if snapshot does exists:
        // accessing "notifications" structure and all it`s child values in snapshot
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            // creating a dictionary for received values from a snapshot
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            // getting user uid from a notification`s structure
            guard let uid = dictionary["uid"] as? String else { return }
            // Fetching user by uid in notifications structure
            UserService.shared.fetchUser(byUid: uid) { user in
                // creating a notification with the received user data and dictionary values to construct a notification
                let notification = Notification(user: user, dictionary: dictionary)
                // adding a notification to notifications array
                notifications.append(notification)
                // passing values to completion block where it`s data can be user later on
                completion(notifications)
            }
        }
    }
    
    /// Fetching notifications from the Database
    func fetchNotifications(completion: @escaping ([Notification]) -> ()) {
        // temporary container to store received notifications`
        let notifications: [Notification] = []
        // getting current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // Checking if user has notifications
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                // if user does not have notifications, returning an empty array
                completion(notifications)
            } else {
                getUserNotification(uid: uid, completion: completion)
            }
        }
    }
}
