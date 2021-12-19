//
//  FeedController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import Foundation
import UIKit

class FeedController: UIViewController {
    
    // MARK: - Properties
    var user: User? {
        didSet {
            configureLetBarButton()
        }
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: Constants.twitterImageBlue)
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    func configureLetBarButton() {
        guard let user = user else { return }

        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        // Downloading an image from url to set it for profileImageView
        UserService.shared.downloadImageTask(with: user.profileImageUrl, for: profileImageView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }

}
