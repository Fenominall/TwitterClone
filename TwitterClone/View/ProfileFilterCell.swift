//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by Fenominall on 12/25/21.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Tweets"
        return label
    }()
    
    // Using isSelected to change the properties of an object when it`s selected
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
            titleLabel.font = isSelected ?
            UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
        }
    }
    	
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}
