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
