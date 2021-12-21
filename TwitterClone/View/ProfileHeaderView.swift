//
//  ProfileHeaderView.swift
//  TwitterClone
//
//  Created by Fenominall on 12/21/21.
//

import Foundation
import UIKit

// Create reusable header for profile controller
class ProfileHeaderView: UICollectionReusableView {
    // MARK: - Properties
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
        return button
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    
    
}
