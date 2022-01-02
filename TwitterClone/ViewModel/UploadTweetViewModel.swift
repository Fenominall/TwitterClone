//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by Fenominall on 1/2/22.
//

import Foundation
import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    
    // MARK: - Properties
    let actionButtonTitle: String
    let placeHolderText: String
    var shouldShowReply: Bool
    var replyToUserText: String?
    
    // MARK: - Lifecycle
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeHolderText = "What`s happening?"
            shouldShowReply = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeHolderText = "Tweet your reply"
            shouldShowReply = true
            replyToUserText = "Replying to @\(tweet.user.username)"
        }
    }
    
}
