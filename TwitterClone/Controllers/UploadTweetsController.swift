//
//  UploadTweetsController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/17/21.
//

import UIKit

class UploadTweetsController: UIViewController {
    
    // MARK: - Properties
    private let user: User
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        return imageView
    }()
    
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        print("DEBUG: The user is \(user.username)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        //        view.backgroundColor = .red
    }
    // MARK: - Selectors
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleUploadTweet() {
        print("DEBUG")
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                left: view.safeAreaLayoutGuide.leftAnchor,
                                paddingTop: 16, paddingLeft: 16)
        
//        profileImageView.image = user.profileImageUrl
      
    }
    
    private func configureNavigationBar() {
        // Left bar button item to cancel
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        // Right bar button item to upload tweet
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
}
