//
//  ProfileCell.swift
//  TwitterClone
//
//  Created by Fenominall on 1/19/22.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    // MARK: - Properties
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        return textField
    }()
    
    let bioTextView: InputTextView = {
        let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .twitterBlue
        textView.placeholderLabel.text = "What`s happening?"
        return textView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          paddingTop: 12,
                          paddingLeft: 16)
        contentView.addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor,
                             left: titleLabel.rightAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 4,
                             paddingLeft: 16,
                             paddingRight: 8)
        contentView.addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor,
                     left: titleLabel.rightAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor,
                     paddingTop: 4,
                     paddingLeft: 16,
                     paddingRight: 8)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUpdateUserInfo),
                                               name: UITextView.textDidEndEditingNotification,
                                               object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        
        titleLabel.text = viewModel.titleText
        
        infoTextField.text = viewModel.optionValue
        
        bioTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceholderLabel
        bioTextView.text = viewModel.optionValue
    }
}
