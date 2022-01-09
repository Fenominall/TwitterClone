//
//  Tweet.swift
//  TwitterClone
//
//  Created by Fenominall on 12/19/21.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    let uid: String
    let likes: Int
    var timestamp: Date!
    let retweetCount: Int
    var didLike = false
    // Fetching user for a tweet
    // getting user for a corresponding tweet it belong to
    var user: User
    
    init(user: User, tweetID: String, dictionary: [String: AnyObject]) {
        self.tweetID = tweetID
        self.user = user

        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    
}
