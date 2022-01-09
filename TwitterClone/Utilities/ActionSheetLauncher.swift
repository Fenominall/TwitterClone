//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Fenominall on 1/5/22.
//

import Foundation
import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: AnyObject {
    func didSelectOption(option: ActionSheetOptions)
}


class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties

    
    private let user: User
    // Make the property lazy to use actionSheetViewModel only when user is initialized
    private lazy var actionSheetViewModel = ActionSheetViewModel(user: user)
    
    private let tableView = UITableView()
    // Accessing UIWindow to show tableView on a separate UIWindow in UIViewController
    private var window: UIWindow?
    weak var delegate: ActionSheetLauncherDelegate?
    // Defining tableView height
    private var tableViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        // Getting faded color over the view
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingLeft: 12,
                            paddingRight: 12)
        
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
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
            self.showTableView(false)
        }
    }
    
    // MARK: - Helpers
    
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHeight else { return }
        
        let yCoordinate = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = yCoordinate

    }
    
    func showSheet() {
        // Presenting UIWindow over all other views
        guard let window = UIApplication.shared.keyWindow else { return }
        
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(tableView)
        // Defining tableView height based on the count of tweeterOptions + "100" for footerView
        let height = CGFloat(actionSheetViewModel.tweetOptions.count * 60) + 100
        self.tableViewHeight = height
        // settings auto layout constraints for tableView
        tableView.frame = CGRect(x: 0,
                                 // set the black view to be the entire screen
                                 y: window.frame.height,
                                 width: window.frame.width,
                                 height: height)
        // Animation to smoothly move tableView up on the set height in y
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            // with the animation table view will be moved up
            self.showTableView(true)
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 7
        tableView.isScrollEnabled = false
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
}

// MARK: - ActionSheetLauncher UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionSheetViewModel.tweetOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.tweetOptions = actionSheetViewModel.tweetOptions[indexPath.row]
        return cell
    }
}

// MARK: - ActionSheetLauncher UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // accessing tweetOptions by it`s indexPath
        let option = actionSheetViewModel.tweetOptions[indexPath.row]
        // when an option is selected didSelectOption will fire with the animation hide action sheet and perform actions
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        } completion: { _ in
            self.delegate?.didSelectOption(option: option)
        }

    }
}
