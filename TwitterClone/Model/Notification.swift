//
//  Notification.swift
//  TwitterClone
//
//  Created by Fenominall on 1/9/22.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    let tweetID: String?
    var timestamp: Date!
    let user: User
    // Tweet is optional because a notification might not always be associated with Tweet
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
        
        self.tweetID = dictionary["tweetID"] as? String ?? ""
        
        if let timeStamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timeStamp)
        }
        
        // based on the type of Notification struct will be build to display info in the Notification Controller
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
