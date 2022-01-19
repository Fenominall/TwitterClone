//
//  EditProfileHeader.swift
//  TwitterClone
//
//  Created by Fenominall on 1/19/22.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    // MARK: - Properties
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: CachedImageView = {
        let image = CachedImageView()
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 3
        image.setDimensions(width: 100, height: 100)
        image.layer.cornerRadius = 100 / 2
        return image
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor  = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self,
                                  topAnchor: profileImageView.bottomAnchor,
                                  paddingTop: 8)
        
        profileImageView.loadImage(withURL: user.profileImageUrl as NSURL?)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
    // MARK: - Helpers

    
}
