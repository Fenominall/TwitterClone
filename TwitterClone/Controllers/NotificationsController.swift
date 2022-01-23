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
    
    // MARK: - Selectors
    
    // Handeling Notifications tableView data refreshing
    @objc func handleRefresh() {
        fetchNotifications()
    }
    
    // MARK: - API
    func fetchNotifications() {
        // Once a user swaps down a table view, a refresh control is activated
        refreshControl?.beginRefreshing()
        // Fetching for all user`s notifications
        NotificationService.shared.fetchNotifications { [weak self] notifications in
            print("DEBUG NO Notifications")
            // Once data received refresh control stops refreshing
            self?.refreshControl?.endRefreshing()
            // assigning the values to be stored in notifications array to be used further
            self?.notifications = notifications
            // checking if a user is follow to display a correct-label for follow button
            self?.checkIfUserIsFollowed(notifications: notifications)
        }
        // If user does not have notification yet, refreshControl ends.
        refreshControl?.endRefreshing()
    }
    
    /// logic to determine if user is followed or not to display the correct followButton`s label text
    func checkIfUserIsFollowed(notifications: [Notification]) {
        // checking if notifications array is empty
        guard !notifications.isEmpty else { return }
        
        notifications.forEach { notification in
            // check to see if type of notification is .follow
            guard case .follow = notification.type else { return }
            // getting a user from a notification
            let user = notification.user
            // Checking on the database if a user is followed or not
            UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                // getting the index of a looked notification as a data source by it`s index
                if let index = self.notifications.firstIndex(where: { $0.user.uid == notification.user.uid }) {
                    // updating tableView dataSource by user [index]
                    self.notifications[index].user.isFollowed = isFollowed
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
        
        // Adding refresh control to a tableView, when a user drags a tableView from top to bottom, the tableView is updated
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
}

// MARK: - UITableViewDataSource
extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        // NotificationCell becomes a delegate for NotificationsController
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
        guard let user = cell.notification?.user else { return }
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (error, reference) in
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (error, reference) in
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        // getting a user data from a selected cell to safely unwrap it
        guard let user = cell.notification?.user else { return }
        
        let profileController = ProfileController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
        
    }
}
