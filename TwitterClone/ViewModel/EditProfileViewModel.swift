//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by Fenominall on 1/19/22.
//

import Foundation

//defined as Int to user it as indexpath for UitableView
enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .username: return "Username"
        case .fullname: return "Name"
        case .bio: return "Bio"
        }
    }
}

struct EditProfileViewModel {
    // MARK: - Properties
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .fullname:
            return user.fullname
        case .username:
            return user.username
        case .bio:
            return user.bio
        }
    }
    
    // Hide TextField for a cell if option is "bio"
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    // Hide TextView for a cell if option is not "bio"
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    // Hiding text in a text view if user has bio
    var shouldHidePlaceholderLabel: Bool {
        return user.bio == nil
    }
    
    // MARK: - Lifecycle
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
