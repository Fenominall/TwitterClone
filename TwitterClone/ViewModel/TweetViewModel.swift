//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Fenominall on 12/20/21.
//

import Foundation
import UIKit

struct TweetViewModel {
    // MARK: - Properties
    let tweet: Tweet
    let user: User
    
    var profileImageURL: URL? {
        return user.profileImageUrl
    }
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let timeNow = Date()
        return formatter.string(from: tweet.timestamp, to: timeNow) ?? "2m"
        
        
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: "・\(timeStamp)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        return title
    }
    // MARK: - Lifecycle
    // designated initializer for "User" and "Tweet" models
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}
