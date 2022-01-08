//
//  TweetController.swift
//  TwitterClone
//
//  Created by Fenominall on 1/1/22.
//

import UIKit

private let reuseTweetIdentifier = "TweetCell"
private let headerTweetIdentifier = "TweetHeader"

class TweetDetailsController: UICollectionViewController {
    
    // MARK: - Properties
    // Marking tweet a class level variable to be able get it outside of the initializer anywhere in the class.
    private let tweet: Tweet
    // creating an instance of ActionSheetLauncher to get access to its methods
    private let actionSheetLauncher: ActionSheetLauncher
    // creating new list to store tweet replies, when new new reply appears then collectionView is reloaded.
    private var repliedTweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
        
    // MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        // initializing actionSheetLauncher with the referenced user
        self.actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    // MARK: - API
    func fetchReplies() {
        TweetService.shared.fetchTweetsReplies(forTweet: tweet) { replies in
            self.repliedTweets = replies
        }
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    func configureCollectionView() {
        // adding reusable TweetCell to ProfileController
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseTweetIdentifier)
        // adding reusable ProfileHeaderView to ProfileController
        collectionView.register(TweetDetailsHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerTweetIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension TweetDetailsController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repliedTweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseTweetIdentifier, for: indexPath) as! TweetCell
        cell.tweet = repliedTweets[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
// adding header to ProfileController
extension TweetDetailsController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: headerTweetIdentifier,
                                                                     for: indexPath) as! TweetDetailsHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TweetDetailsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let tweetViewModel = TweetViewModel(tweet: tweet)
        let captionHeight = tweetViewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}


extension TweetDetailsController: TweetHeaderDelegate {
    func showActionSheet() {
        actionSheetLauncher.showSheet()
    }
    
    
}
