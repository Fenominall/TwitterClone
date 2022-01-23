//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Fenominall on 12/19/21.
//

import UIKit
import ActiveLabel

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleFetchUser(withUsername username: String)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties

    // Populating tweet cell, whenever the property gets set with the data received from the FeedController
    var tweet: Tweet? {
        didSet { configure() }
    }
    weak var delegate: TweetCellDelegate?
    
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
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.mentionColor = (.twitterBlue ?? .lightGray)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.mentionColor = (.twitterBlue ?? .lightGray)
        label.hashtagColor = (.twitterBlue ?? .lightGray)
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
        let button = createButton(withImageName: Constants.commentsImage)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: Constants.retweetImage)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: Constants.likeImage)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: Constants.shareImage)
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
        
        // 1
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,
                                                               infoStackView])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        // 2
        let imageCaptionStackWithReply = UIStackView(arrangedSubviews: [replyLabel,
                                                                        imageCaptionStack])
        imageCaptionStackWithReply.axis = .vertical
        imageCaptionStackWithReply.distribution = .fillProportionally
        imageCaptionStackWithReply.spacing = 8
        
        addSubview(imageCaptionStackWithReply)
        imageCaptionStackWithReply.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 4,
                             paddingLeft: 12,
                             paddingRight: 12)
        // By default replyLabel is hidden
        replyLabel.isHidden = true
        // Setting a font size of infoLabel(Full name and username)
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             height: 1)
        
        addSubview(actionStack)
        actionStack.anchor(top: imageCaptionStackWithReply.bottomAnchor,
                           paddingTop: 30)
        actionStack.anchor(left: leftAnchor,
                           right: rightAnchor,
                           paddingLeft: 45,
                           paddingBottom: 16,
                           paddingRight: 45)
        actionStack.centerX(inView: self)
        // When user taps on mention will be redirected to a profile of a tapped username
        configureMentionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }

    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    @objc func handleRetweetTapped() {
        
    }
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
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
        
        likeButton.tintColor = tweetViewModel.likeButtonTintColor
        likeButton.setImage(tweetViewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = tweetViewModel.shouldHideReplyLabel
        replyLabel.text = tweetViewModel.whoRepliedText
    }

    func configureMentionHandler() {
        captionLabel.handleMentionTap { [weak self] username in
            self?.delegate?.handleFetchUser(withUsername: username)
        }
        replyLabel.handleMentionTap { [weak self] username in
            self?.delegate?.handleFetchUser(withUsername: username)
        }
    }
    
    
    func createButton(withImageName imageName: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(imageName, for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
}
