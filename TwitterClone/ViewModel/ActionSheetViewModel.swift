//
//  ActionSheetViewModel.swift
//  TwitterClone
//
//  Created by Fenominall on 1/8/22.
//

import Foundation

struct ActionSheetViewModel {
    
    // MARK: - Properties
    private let user: User
    
    // computed property to show different options on tweet options based on the cases if it`s current user or not
    // if the user if followed or not
    var tweetOptions: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        results.append(.report)
        return results
    }
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
    }
}

// MARK: - ActionSheetOptions
enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
        }
    }
}
