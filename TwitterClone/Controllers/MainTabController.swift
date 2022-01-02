//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    private(set) lazy var actionButton: UIButton = {
        let actionButton = UIButton(type: .system)
        actionButton.configuration = .blueStickyButton()
        actionButton.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        actionButton.clipsToBounds = true
        actionButton.layer.cornerRadius = actionButton.frame.size.width / 2
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return actionButton
    }()
    
    // MARK: - ViewController Lifecycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
//        logUserOut()
        authenticateUserAndConfigureUI()
    }
    
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        
        let uploadTweetController = UploadTweetsController(user: user, config: .tweet)
        let uploadTweetNav = UINavigationController(rootViewController: uploadTweetController)
        uploadTweetNav.modalPresentationStyle = .fullScreen
        present(uploadTweetNav, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = UINavigationController(rootViewController: LoginController())
                loginController.modalPresentationStyle = .fullScreen
                self.present(loginController, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
    }
    
    func configureViewControllers() {
        // TabBar appearance
        tabBar.backgroundColor = .white
        // Settings View Controllers in TabBar
        let feedNavController = templateNavigationController(image: Constants.homeImage,
                                                             rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        let exploreNavController = templateNavigationController(image: Constants.exploreImage,
                                                                rootViewController: ExploreController())
        let notificationsNavController = templateNavigationController(image: Constants.notificationsImage,
                                                                      rootViewController: NotificationsController())
        let conversationsNavController = templateNavigationController(image: Constants.feedImage,
                                                                      rootViewController: ConversationsController())
        viewControllers = [feedNavController,
                           exploreNavController,
                           notificationsNavController,
                           conversationsNavController]
    }
}

// MARK: - Creating NavigationController for ViewControllers
extension MainTabController {
    func templateNavigationController(image: UIImage?,
                                      rootViewController: UIViewController) -> UINavigationController {
        // NavBar appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        // Creating NavBar and assigning the properties
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        // NavBar appearance
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
//                navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
}

