//
//  EditProfileFotter.swift
//  TwitterClone
//
//  Created by Fenominall on 1/23/22.
//

import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func handleLogOut()
}

class EditProfileFooter: UIView {
    // MARK: - Properties
    
    weak var delegate: EditProfileFooterDelegate?
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logOutButton)
        logOutButton.anchor(left: leftAnchor,
                            right: rightAnchor,
                            paddingLeft: 16,
                            paddingRight: 16)
        logOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logOutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleLogOut() {
        delegate?.handleLogOut()
    }
    // MARK: - Helpers
}
