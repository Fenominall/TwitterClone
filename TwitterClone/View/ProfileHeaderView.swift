//
//  ProfileHeaderView.swift
//  TwitterClone
//
//  Created by Fenominall on 12/21/21.
//

import Foundation
import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeaderView)
}

// Create reusable header for profile controller
class ProfileHeaderView: UICollectionReusableView {
    // MARK: - Properties
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    var user: User? {
        didSet { configureUserData() }
    }
    
    private let filterBar = ProfileFilterView()
    
    private lazy var container: UIView = {
        let container = UIView()
        container.backgroundColor = .twitterBlue
        
        container.addSubview(backButton)
        backButton.anchor(top: container.topAnchor, left: container.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return container
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.backButtonImage, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue?.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLableL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "init(coder:) has not been implemented init(coder:) has not been"
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
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
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    @objc func handleFollowingTapped() {
        
    }
    // MARK: - Helpers
    func configureUI() {

        addSubview(container)
        container.anchor(top: topAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: container.bottomAnchor,
                                left: leftAnchor,
                                paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: container.bottomAnchor,
                                       right: rightAnchor,
                                       paddingTop: 12, paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailStack  = UIStackView(arrangedSubviews: [fullnameLabel,
                                                              usernameLabel,
                                                              bioLableL])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fill
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        
        userDetailStack.anchor(top: profileImageView.bottomAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               paddingTop: 12,
                               paddingLeft: 12,
                               paddingRight: 12)
        
        let followersStack = UIStackView(arrangedSubviews: [followersLabel,
                                                            followingLabel])
        followersStack.axis = .horizontal
        followersStack.spacing = 8
        followersStack.distribution = .fillEqually
        addSubview(followersStack)
        followersStack.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.filterDelegate = self
        filterBar.anchor(left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         height: 50)
        
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             width: frame.width / 3,
                             height: 2)
    }
    
    func configureUserData() {
        guard let user = user else { return }
        let profileViewModel = ProfileHeaderViewModel(user: user)
        profileImageView.loadImage(withURL: user.profileImageUrl as NSURL?)
        editProfileFollowButton.setTitle(profileViewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = profileViewModel.followingString
        followersLabel.attributedText = profileViewModel.followersString
        
        fullnameLabel.text = profileViewModel.fullName
        usernameLabel.text = profileViewModel.username
    }
}

// MARK: - ProfileFilterViewDelegate
extension ProfileHeaderView: ProfileFilterViewDelegate {
    func animateFilterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        // got the cell for a corresponding indexPath
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {
            return
        }
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
    
    
}
