//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Fenominall on 1/5/22.
//

import Foundation
import UIKit

private let reuseIdentifier = "ActionSheetCell"

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    private let user: User
    private let tableView = UITableView()
    // Accessing UIWindow to show tableView on a separate UIWindow in UIViewController
    private var window: UIWindow?
    
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    
    // MARK: - Helpers
    func showSheet() {
        // Presenting UIWindow over all other views
        guard let window = UIApplication.shared.keyWindow else { return }
        
        self.window = window
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0,
                                 y: window.frame.height - 300,
                                 width: window.frame.width,
                                 height: 300)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
}

// MARK: - ActionSheetLauncher UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

// MARK: - ActionSheetLauncher UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    
}
