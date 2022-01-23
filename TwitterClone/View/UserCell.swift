//
//  UserCell.swift
//  TwitterClone
//
//  Created by Fenominall on 12/26/21.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    private lazy var profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .twitterBlue
        imageView.setDimensions(width: 40, height: 40)
        imageView.layer.cornerRadius = 40 / 2
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private let userFullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test User"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: self,
                                 leftAnchor: leftAnchor,
                                 paddingLeft: 12)
        
        let infoStack = UIStackView(arrangedSubviews: [usernameLabel,
                                                       userFullnameLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 2
        addSubview(infoStack)
        infoStack.centerY(inView: self,
                          leftAnchor: profileImageView.rightAnchor,
                          paddingLeft: 12)
    }
    
    func createButton(withImageName imageName: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(imageName, for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    func configure() {
        guard let user = user else { return }
        
        ImageService.shared.downloadAndSetImage(with: user.profileImageUrl, for: profileImageView)
        usernameLabel.text = user.username
        userFullnameLabel.text = user.fullname
    }
    
}
