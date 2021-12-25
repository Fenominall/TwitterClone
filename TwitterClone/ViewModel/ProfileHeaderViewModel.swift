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
    
    var followersString: NSAttributedString? {
        attributedButton(withValue: 0, text: " followers")
    }
    
    var followingString: NSAttributedString? {
        attributedButton(withValue: 0, text: " following")
    }
    
    var actionButtonTitle: String {
        // if user is current user then set to edit profile
        // else figure out following/not following
        user.isCurrentUser ? "Edit profile" : "Follow"
    }
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func attributedButton(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes:
                                                            [.font: UIFont.boldSystemFont(ofSize: 14),
                                                             .foregroundColor: UIColor.black])
        attributedTitle.append(NSMutableAttributedString(string: "\(text)", attributes:
                                                            [.font: UIFont.systemFont(ofSize: 14),
                                                             .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
