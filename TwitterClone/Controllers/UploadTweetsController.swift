//
//  UploadTweetsController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/17/21.
//

import UIKit
import Foundation
import ActiveLabel

class UploadTweetsController: UIViewController {
    
    // MARK: - Properties
    private let user: User
    private let tweetConfig: UploadTweetConfiguration
    // The property is lazy because "tweetConfig" is not set
    private lazy var uploadTweetViewModel = UploadTweetViewModel(config: tweetConfig)
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    // UIImageView with a custom class for caching Images provided by URL
    //    or download them if cache not found
    private let profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        return imageView
    }()
    
    // Special active label that can shown different color and can have a tappable possibility
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = (.twitterBlue ?? .lightGray)
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    private lazy var imageCaptionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .leading
        
        return stack
    }()
    
    // MARK: - Lifecycle
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.tweetConfig = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureUIComponents()
    }
    
    // MARK: - Selectors
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // Guard checks if captionTextView has text and then uploads tweet to a database if it`s successful.
    @objc private func handleUploadTweet() {
        // Guard checks if captionTextView has text and then uploads tweet to a database if it`s successful.
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: tweetConfig) { [weak self] (error, reference) in
            // reference is reference to the tweet
            if let error = error {
                print("DEBUG: Failed to upload a tweet with error: \(error.localizedDescription)")
                return
            }
            
            // Check if the state is in the reply configuration to get access to tweet properties
            if case .reply(let tweet) = self?.tweetConfig {
                // Uploading notification to notify the user about reply on the tweet
                NotificationService.shared.uploadNotification(toUser: tweet.user,
                                                              type: .reply,
                                                              tweetID: tweet.tweetID)
            }
            // if a tweet was replied the user will get mentioned notification
            self?.uploadMentionedNotification(forCaption: caption, tweetID: reference.key)
            // After tweet is successfully uploaded navigation-controller dismiss the current view to controller
            self?.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - API
    
    private func uploadMentionedNotification(forCaption caption: String, tweetID: String?) {
        // checking if caption has @
        guard caption.contains("@") else { return }
        // deciding caption array of words with whitespacesAndNewlines
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        // iterating over each word
        words.forEach { word in
            // checking if a word has "@" mentioned prefix
            guard word.hasPrefix("@") else { return }
            
            var username = word.trimmingCharacters(in: .symbols)
            username = username.trimmingCharacters(in: .punctuationCharacters)
            // Fetching a  mentioned user by username in users-usernames structure where it gets fetched user`s uid and gets reference to the actual user structure
            UserService.shared.fetchUser(withUsername: username) { mentioned in
                // Uploading mention notification to notify the mentioned user about actions provided on his profile
                NotificationService.shared.uploadNotification(toUser: mentioned,
                                                              type: .mention,
                                                              tweetID: tweetID)
            }
        }
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let tweetStack = UIStackView(arrangedSubviews: [replyLabel,
                                                       imageCaptionStack])
        tweetStack.axis = .vertical
        tweetStack.spacing = 12
        
        view.addSubview(tweetStack)
        tweetStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 16,
                              paddingLeft: 16,
                              paddingRight: 16)
        
        // Representing userProfile cached image, if cache not found the image will downloaded from provided URL
        profileImageView.loadImage(withURL: user.profileImageUrl as NSURL?)
    }
    
    func configureUIComponents() {
        // if user selects upload new tweet title will be set to "Tweet"s
        // else title will be "Reply" based on enum switch
        actionButton.setTitle(uploadTweetViewModel.actionButtonTitle, for: .normal)
        captionTextView.placeHolderLabel.text = uploadTweetViewModel.placeHolderText
        replyLabel.isHidden = !uploadTweetViewModel.shouldShowReply
        guard let replyText = uploadTweetViewModel.replyToUserText else { return }
        replyLabel.text = replyText
    }
    
    private func configureNavigationBar() {
        // Left bar button item to cancel
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        // Right bar button item to upload tweet
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}

