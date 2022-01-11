//
//  NotificationsController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import Foundation
import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    // MARK: - Properties
    private var notifications = [Notification]() {
        // each time data received table view is being reloaded by didSet
        didSet { tableView.reloadData() }
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - API
    func fetchNotifications() {
        // fetching for all user`s notifications
        NotificationService.shared.fetchNotifications { notifications in
            // assigning the values to be stored in notifications array to be used further
            self.notifications = notifications
            
            // logic to determine if user is followed or not to display the correct followButton`s label text
            for (index, notification) in notifications.enumerated() {
                // check to see if type of notification is .follow
                if case .follow = notification.type {
                    // getting a user from a notification
                    let user = notification.user
                    // Checking on the database if a user if follower or not
                    UserService.shared.checkIfUserIsFollowing(uid: user.uid) { isFollowed in
                        // getting index of a correct data source by it`s index
                        // updating tableView dataSource by user [index]
                        self.notifications[index].user.isFollowed = isFollowed
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        
    }
}

// MARK: - UItableViewDataSource
extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // getting a notification from a selected row by it`s indexPath
        let notification = notifications[indexPath.row]
        // safely unwrapping tweetID from a notification, cause in a cell we won`t always have notifications related to tweets
        guard let tweetID = notification.tweetID else { return }
        // Fetching a tweet by tweetID on the Database
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            // Creating an instance of TweetDetailsController and passing a received tweet to it
            let tweetController = TweetDetailsController(tweet: tweet)
            self.navigationController?.pushViewController(tweetController, animated: true)
        }
    }
}


// MARK: - NotificationCellDelegate
extension NotificationsController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        print("DEBUG: Handle follow tapped")
//        guard let user = cell.notification?.user else { return }
        
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        // getting a user data from a selected cell to safely unwrap it
        guard let user = cell.notification?.user else { return }
        
        let profileController = ProfileController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
        
    }
}
