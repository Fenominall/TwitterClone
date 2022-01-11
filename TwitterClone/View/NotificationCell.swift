//
//  NotificationCell.swift
//  TwitterClone
//
//  Created by Fenominall on 1/10/22.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    // MARK: - Properties
    
    var notification: Notification? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 40, height: 40)
        imageView.layer.cornerRadius = 40 / 2
        imageView.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()

    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.twitterBlue, for: .normal)
        button.layer.borderColor = UIColor.twitterBlue?.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,
                                                  notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        // User contentView to activate actions for added elements on a custom UITAbleViewCell
        contentView.addSubview(stack)
        stack.centerY(inView: self,
                      leftAnchor: leftAnchor,
                      paddingLeft: 12)
        
        stack.anchor(right: rightAnchor,
                     paddingRight: 12)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 92, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    // Passing the user to user`s profile when ProfileImage is tapped
    @objc func handleProfileImageTapped() {
        delegate?.didTapProfileImage(self)
    }
    
    @objc func handleFollowTapped() {
        delegate?.didTapFollow(self)
    }
    
    // MARK: - Helpers
    func configure() {
        guard let notification = notification else { return }

        let notificationViewModel = NotificationsViewModel(notification: notification)
        
        profileImageView.loadImage(withURL: notificationViewModel.profileImageUrl as NSURL?)
        notificationLabel.attributedText = notificationViewModel.notificationText
        followButton.isHidden = notificationViewModel.shouldHideFollowButton
        followButton.setTitle(notificationViewModel.followButtonText, for: .normal)
    }
}
