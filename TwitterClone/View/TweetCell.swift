//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Fenominall on 12/19/21.
//

import UIKit

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties

    // Populating tweet cell, whenever the property gets set with the data received from the FeedController
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    private let profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "Some test caption"
        return label
    }()
    
    private let infoLabel = UILabel()
    
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoLabel,
                                                   captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()

    // UnderlineView
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
        
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.commentsImage, for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.retweetImage, for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.likeImage, for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.setImage(Constants.shareImage, for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [commentButton,
                                                  retweetButton,
                                                  likeButton,
                                                  shareButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,
                                left: leftAnchor,
                                paddingTop: 8,
                                paddingLeft: 8)
        
        infoLabel.text = "Vlad @Ven0m"
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(infoStackView)
        infoStackView.anchor(top: profileImageView.topAnchor,
                             left: profileImageView.rightAnchor,
                             paddingLeft: 12,
                             paddingRight: 12)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             height: 1)
        
        addSubview(actionStack)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        actionStack.anchor(left: leftAnchor,
                           bottom: bottomAnchor,
                           right: rightAnchor,
                           paddingLeft: 45,
                           paddingBottom: 8,
                           paddingRight: 45)
        actionStack.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors

    @objc func handleCommentTapped() {
        
    }
    @objc func handleRetweetTapped() {
        
    }
    @objc func handleLikeTapped() {
        
    }
    @objc func handleShareTapped() {
        
    }
    // MARK: - Helpers

    func configure() {
        guard let tweet = tweet else { return }
        let tweetViewModel = TweetViewModel(tweet: tweet)
        
        // configuring fetched tweet`s data with each tweet`s element
        captionLabel.text = tweet.caption
        profileImageView.loadImage(withURL: tweetViewModel.profileImageURL as NSURL?)
        infoLabel.attributedText = tweetViewModel.userInfoText
        
    }
}
