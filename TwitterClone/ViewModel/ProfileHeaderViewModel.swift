//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Fenominall on 12/25/21.
//

import UIKit
import Foundation

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    // updating followers label with followers count of the user
    var followersString: NSAttributedString? {
        attributedText(withValue: user.stats?.followers ?? 0, text: " followers")
    }
    // updating following label with following count of the user
    var followingString: NSAttributedString? {
        attributedText(withValue: user.stats?.following ?? 0, text: " following")
    }
    
    var actionButtonTitle: String {
        // if user is current user then set to edit profile
        // else figure out following/not following
        if user.isCurrentUser {
            return "Edit profile"
        }

        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        if user.isFollowed {
            return "Following"
        }
        return "Loading"
    }
    
    var fullName: String {
        user.fullname
    }
    
    var username: String {
        "@\(user.username)"
    }
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes:
                                                            [.font: UIFont.boldSystemFont(ofSize: 14),
                                                             .foregroundColor: UIColor.black])
        attributedTitle.append(NSMutableAttributedString(string: "\(text)", attributes:
                                                            [.font: UIFont.systemFont(ofSize: 14),
                                                             .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
