//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
      
    }
    
    // MARK: - Helpers
    
    func configureViewControllers() {
        // TabBar appearance
        tabBar.backgroundColor = .white
        // Settings View Controllers in TabBar
        let feedNavController = templateNavigationController(image: Constants.homeImage,
                                                             rootViewController: FeedController())
        let exploreNavController = templateNavigationController(image: Constants.exploreImage,
                                                                rootViewController: ExploreController())
        let notificationsNavController = templateNavigationController(image: Constants.notificationsImage,
                                                                      rootViewController: NotificationsController())
        let conversationsNavController = templateNavigationController(image: UIImage(named: "home_unselected"),
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
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
}

