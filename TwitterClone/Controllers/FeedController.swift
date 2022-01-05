//
//  FeedController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import Foundation
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
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
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
        
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
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
