//
//  UploadTweetsController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/17/21.
//

import UIKit

class UploadTweetsController: UIViewController {
    
    // MARK: - Properties
    private let user: User
    
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
    
    private let captionTextView = CaptionTextView()
    
    private lazy var tweetStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        return stack
    }()
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // Guard checks if captionTextView has text and then uploads tweet to a database if it`s successful.
    @objc private func handleUploadTweet() {
        // Guard checks if captionTextView has text and then uploads tweet to a database if it`s successful.
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption) { [weak self] (error, reference) in
            if let error = error {
                print("DEBUG: Failed to upload a tweet with error: \(error.localizedDescription)")
                return
            }
            // After tweet is successfully uploaded navigation-controller dismiss the current view to controller
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(tweetStackView)
        tweetStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.safeAreaLayoutGuide.leftAnchor,
                              right: view.safeAreaLayoutGuide.rightAnchor,
                              paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        // Representing userProfile cached image, if cache not found the image will downloaded from provided URL
        profileImageView.loadImage(withURL: user.profileImageUrl as NSURL?)
        
    }
    
    private func configureNavigationBar() {
        // Left bar button item to cancel
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        // Right bar button item to upload tweet
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
}
