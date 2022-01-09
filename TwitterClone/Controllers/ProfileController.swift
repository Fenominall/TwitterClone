//
//  ProfileController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/21/21.
//

import Foundation
import UIKit

private let reuseIdentifier = "TweetCell"
private let headerReuseIdentified = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    private var user: User
    
    private var tweets: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        // CollectionView controller has to be initialized
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    // fetching tweets for any user tweets by users` "uid"
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { self.tweets = $0 }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowing(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) {
            self.user.stats = $0
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        // disable safe area in a collection-view controller
        collectionView.contentInsetAdjustmentBehavior = .never
        
        // adding reusable TweetCell to ProfileController
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // adding reusable ProfileHeaderView to ProfileController
        collectionView.register(ProfileHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerReuseIdentified)
        
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
// adding header to ProfileController
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: headerReuseIdentified,
                                                                     for: indexPath) as! ProfileHeaderView
        header.delegate = self
        header.user = user
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - ProfileHeaderViewDelegate
extension ProfileController: ProfileHeaderViewDelegate {
    // implementing the function to follow and unfollow a user
    func handleEditProfileFollow(_ header: ProfileHeaderView) {
        
        //  if user.isCurrentUser then do not create following structure and just return
        if user.isCurrentUser {
            print("DEBUG: Show edit profile controller..")
            return
        }
    
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { [weak self] (error, reference) in
                self?.user.isFollowed = false
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                self?.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { [weak self] (ref, error) in
                self?.user.isFollowed = true
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                self?.collectionView.reloadData()
                // when a user starts being followed a notification about the following is sent
                NotificationService.shared.uploadNotification(type: .follow, user: self?.user)
            }
        }
    }
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}
