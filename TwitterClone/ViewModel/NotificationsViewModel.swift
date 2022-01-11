//
//  NotificationsViewModel.swift
//  TwitterClone
//
//  Created by Fenominall on 1/10/22.
//

import Foundation
import UIKit

struct NotificationsViewModel {
    
    // MARK: - Properties
    private let user: User
    private let notification: Notification
    
    private let type: NotificationType
    
    var notificationMessage: String {
        switch type {
            
        case .follow: return " started following you"
        case .like: return " liked your tweet"
        case .reply: return " replied to your tweet"
        case .retweet: return " retweeted your tweet"
        case .mention: return " mentioned you in a tweet"
        }
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let timeNow = Date()
        return formatter.string(from: notification.timestamp, to: timeNow) ?? "2m"
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        let attributedText = NSMutableAttributedString(string: user.username,
                                                       attributes: [NSAttributedString.Key.font:
                                                                        UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes: [NSAttributedString.Key.font:
                                                                UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)",
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                                              NSMutableAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    /// Hides follow button on non-following notifications
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    // MARK: - Lifecycle
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
