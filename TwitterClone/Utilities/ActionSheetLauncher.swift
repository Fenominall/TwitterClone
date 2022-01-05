//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Fenominall on 1/5/22.
//

import Foundation
import UIKit

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    private let user: User
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init()
    }
    
    // MARK: - Helpers
    func showSheet() {
        print("DEBUG  Show action sheet for user \(user.username)")
    }
    
}
