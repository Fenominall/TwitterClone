//
//  ConversationsController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import Foundation
import UIKit

class ConversationsController: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
