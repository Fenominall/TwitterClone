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
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        // Getting faded color over the view
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    
    // MARK: - Selectors
    // Dismissing with animation tableView and blackView when the user taps on the screen
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }
    
    // MARK: - Helpers
    func showSheet() {
        // Presenting UIWindow over all other views
        guard let window = UIApplication.shared.keyWindow else { return }
        
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0,
                                 // set the black view to be the entire screen
                                 y: window.frame.height,
                                 width: window.frame.width,
                                 height: 300)
        // Animation to smoothly move tableView up on the set height in y
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            // with the animation table view will be moved up
            self.tableView.frame.origin.y -= 300
        }
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
