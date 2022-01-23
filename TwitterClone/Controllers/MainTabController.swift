//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import UIKit
import Firebase

// enum for action on a selected VC
enum ActionButtonConfiguration {
    // action will be provided on all VController except ConversationVC
    case tweet
    // Action on a ConversationVC will be provided
    case message
}

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
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
        authenticateUserAndConfigureUI()
    }
    
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        
        let controller: UIViewController
        guard let user = user else { return }
        
        switch buttonConfig {
        case .tweet:
           controller = UploadTweetsController(user: user, config: .tweet)
        case .message:
            controller = SearchController(configOption: .messages)
        }
        
        let selectedVC = UINavigationController(rootViewController: controller)
        selectedVC.modalPresentationStyle = .fullScreen
        present(selectedVC, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(byUid: uid) { user in
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
        // marking MainTabBarController as a self delegate
        self.delegate = self
        // TabBar appearance
        tabBar.backgroundColor = .white
        // Settings View Controllers in TabBar
        let feedNavController = templateNavigationController(image: Constants.homeImage,
                                                             rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        let exploreNavController = templateNavigationController(image: Constants.exploreImage,
                                                                rootViewController: SearchController(configOption: .userSearch))
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
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        return navigationController
    }
}

// implementing state switch for an action button on the MainTabBar
// if a conversation VC selected the enveloper icon will be shown
// else a regular add icon will be shown
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // getting the index of a selected VC
        let indexOfVC = viewControllers?.firstIndex(of: viewController)
        // Changing the image based on selected VC state
        let actionButtonImage = indexOfVC == 3 ? Constants.mailImage : Constants.newTweetImage
        // setting the image to the action button
        actionButton.setImage(actionButtonImage, for: .normal)
        buttonConfig = indexOfVC == 3 ? .message : .tweet
    }
}
