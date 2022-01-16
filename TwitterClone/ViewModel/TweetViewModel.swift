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
    
    var headerTimeStamp: String {
        let formater = DateFormatter()
        formater.dateFormat = "h:mm a ・ MM/dd/yyyy"
        return formater.string(from: tweet.timestamp)
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var retweetAttributedString: NSAttributedString? {
        attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        attributedText(withValue: tweet.likes, text: "Likes")
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
    
    // changing the color of like button on the tweet if didLike is true
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? Constants.likeImageFilled : Constants.likeImage
        return imageName
    }

    // if tweet is replied label is shown otherwise it`s hidden
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    
    // Will display username of a person who replied to a tweet
    var whoRepliedText: String {
        guard let username = tweet.replyingTo else { return "" }
        return "→ Replying to @\(username)"
    }
    
    // MARK: - Lifecycle
    // designated initializer for "User" and "Tweet" models
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    // MARK: - Helpers
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: " \(value)", attributes:
                                                            [.font: UIFont.boldSystemFont(ofSize: 14),
                                                             .foregroundColor: UIColor.black])
        attributedTitle.append(NSMutableAttributedString(string: " \(text)", attributes:
                                                            [.font: UIFont.systemFont(ofSize: 14),
                                                             .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
