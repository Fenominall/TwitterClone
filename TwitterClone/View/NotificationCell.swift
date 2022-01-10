//
//  NotificationCell.swift
//  TwitterClone
//
//  Created by Fenominall on 1/10/22.
//

import UIKit


class NotificationCell: UITableViewCell {
    // MARK: - Properties
    
    private lazy var profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 40, height: 40)
        imageView.layer.cornerRadius = 40 / 2
        imageView.backgroundColor = .twitterBlue
        let tap = UIGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test Nofitication"
        return label
    }()
    
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,
                                                  notificationLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self,
                      leftAnchor: leftAnchor,
                      paddingLeft: 12)
        stack.anchor(right: rightAnchor,
                     paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        
    }
    
    // MARK: - Helpers
    
}
