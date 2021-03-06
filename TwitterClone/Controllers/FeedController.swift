//
//  FeedController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import Firebase
import UIKit

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Selectors
    @objc private func handleRefresh() {
        fetchTweets()
    }
    
    @objc private func openUserProfile() {
        // getting the user values and checking that it is not nil
        guard let user = user else { return }
        // pushing the user to ProfileVC
        let userProfileVC = ProfileController(user: user)
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    // MARK: - API
    fileprivate func checkIfUserLikedTweet() {
        // with enumerated() you get access to each tweet`s indexPath on each iteration of fro loop
        self.tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                // checking in the database if tweet was liked with the API call
                guard didLike == true else { return }
                // if didLike from API call is true tweet`s model didLike property is set to true
                // tweet property`s didSet reload data and UI is updated
                if let index = self.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID }) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweets { [weak self] tweets in
            // sorting received tweets by date from newest to oldest
            self?.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            self?.checkIfUserLikedTweet()
            // after data fetched and sorted refreshControl stops refreshing
            self?.collectionView.refreshControl?.endRefreshing()
        }
        // If user does not have tweets yet, refreshControl ends.
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: Constants.twitterImageBlue)
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        // Adding a refresh control to refresh user data
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openUserProfile))
        profileImageView.addGestureRecognizer(tap)
        // Downloading an image from url to set it for profileImageView
        ImageService.shared.downloadAndSetImage(with: user.profileImageUrl, for: profileImageView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
}

// MARK: - UICollectionViewDelegate/DataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TweetCell
        // by assigning a delegate to self on this controller, a reference to tweet cell is created
        cell.delegate = self
        // access tweet property and setting it the fetched tweets to be a dataSource
        // Populating tweet cell, whenever the property gets set with the data received from the FeedController
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetDetailsController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    // adjusting tweet`s size in a collectionView cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweetViewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = tweetViewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 100)
    }
}

// MARK: - TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { [weak self] user in
            let controller = ProfileController(user: user)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleLikeTapped(_ cell: TweetCell) {
        // safely unwrapping the tweet from a cell
        guard let tweet = cell.tweet else { return }
        // Calling likeTweet func and passing unwrapped tweet
        TweetService.shared.likeTweet(tweet: tweet) { (error, reference) in
            cell.tweet?.didLike.toggle()
            // settings the likes value on the "likes" property
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            // after likes value updated on the Database, the data about likes updated on the client side to keep data in sync
            cell.tweet?.likes = likes
            
            // only upload notification if a tweet is being liked and didLike property is set to true
            guard !tweet.didLike else { return } // if tweet > didLike is true, then call NotificationService
            NotificationService.shared.uploadNotification(toUser: tweet.user, type: .like, tweetID: tweet.tweetID)
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetsController(user: user, config: .reply(tweet))
        let uploadTweetNav = UINavigationController(rootViewController: controller)
        uploadTweetNav.modalPresentationStyle = .fullScreen
        present(uploadTweetNav, animated: true, completion: nil)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        // getting a specific user for a selected cell
        guard let user = cell.tweet?.user else { return }
        let profileController = ProfileController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
