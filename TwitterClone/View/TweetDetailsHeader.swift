//
//  TweetHeader.swift
//  TwitterClone
//
//  Created by Fenominall on 1/1/22.
//

import UIKit

class TweetDetailsHeader: UICollectionReusableView {
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet { configureTweet() }
    }
    
    private lazy var profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        // for use of tapping behavior on a non button object
        let tab = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tab)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.downArrowImage, for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(showSettingsSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsCountLabel = UILabel()
    
    private lazy var likesCountLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        
        let dividerOne = UIView()
        dividerOne.backgroundColor = .systemGroupedBackground
        view.addSubview(dividerOne)
        dividerOne.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingLeft: 8,
                          height: 1.0)
        let stack = UIStackView(arrangedSubviews: [retweetsCountLabel,
                                                   likesCountLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor,
                     paddingLeft: 16)
        
        let dividerTwo = UIView()
        dividerTwo.backgroundColor = .systemGroupedBackground
        view.addSubview(dividerTwo)
        dividerTwo.anchor(left: view.leftAnchor,
                          bottom: view.bottomAnchor,
                          right: view.rightAnchor,
                          paddingLeft: 8,
                          height: 1.0)
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: Constants.commentsImage)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: Constants.retweetImage)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likesButton: UIButton = {
        let button = createButton(withImageName: Constants.likeImage)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: Constants.shareImage)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc private func handleProfileImageTapped() {
        print("DEBUG go to user profile")
    }
    
    @objc private func showSettingsSheet() {
        print("DEBUG show action sheet")
    }
    
    @objc private func handleCommentTapped() {
        
    }
    
    @objc private func handleRetweetTapped() {
        
    }
    
    @objc private func handleLikeTapped() {
        
    }
    
    @objc private func handleShareTapped() {
        
    }
    
    
    // MARK: - Helpers
    func configureUI() {
        
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel,
                                                        usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageLabelStack  = UIStackView(arrangedSubviews: [profileImageView,
                                                              labelStack])
        imageLabelStack.spacing = 12
        
        addSubview(imageLabelStack)
        imageLabelStack.anchor(top: topAnchor,
                               left: leftAnchor,
                               paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: imageLabelStack.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 20,
                            paddingLeft: 16,
                            paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor,
                         left: leftAnchor,
                         paddingTop: 20,
                         paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: imageLabelStack)
        optionsButton.anchor(right: rightAnchor,
                             paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingTop: 20,
                         height: 40.0)
        
        let actionsStack = UIStackView(arrangedSubviews: [commentButton,
                                                          retweetButton,
                                                          likesButton,
                                                          shareButton])
        actionsStack.spacing = 72
        addSubview(actionsStack)
        actionsStack.centerX(inView: self)
        actionsStack.anchor(bottom: bottomAnchor,
                            paddingTop: 8,
                            paddingBottom: 12)
    }
    
    func createButton(withImageName imageName: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(imageName, for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    func configureTweet() {
        guard let tweet = tweet else { return }
        
        let tweetViewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullNameLabel.text = tweetViewModel.user.fullname
        usernameLabel.text = tweetViewModel.usernameText
        dateLabel.text = tweetViewModel.headerTimeStamp
        retweetsCountLabel.attributedText = tweetViewModel.retweetAttributedString
        likesCountLabel.attributedText = tweetViewModel.likesAttributedString
        profileImageView.loadImage(withURL: tweetViewModel.profileImageURL as NSURL?)
        
        
    }
    
    
    
}
