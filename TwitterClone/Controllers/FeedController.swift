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
        navigationItem.titleView = imageView
    }

}
