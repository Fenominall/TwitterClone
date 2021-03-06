//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/5/21.
//

import Foundation
import UIKit

private let reuseIdentifier = "UserCell"

// Based on the selected option SearchController will be reused for messages or userSearch
enum SearchControllerConfiguration {
    case messages
    case userSearch
}

class SearchController: UITableViewController {
    
    // MARK: - Properties
    // injecting SearchControllerConfigurations to be able to select to config  option when initializing SearchController in the app
    private let configOption: SearchControllerConfiguration
    
    private var users: [User] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var filteredUsers = [User]() {
        didSet { tableView.reloadData() }
    }
    
    // if search mode is activated,
    // users array will be switched to a new filtered users array
    private var  inSearchMode: Bool {
        return searchController.isActive &&
        !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - ViewController Lifecycle
    init(configOption: SearchControllerConfiguration) {
        self.configOption = configOption
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    private func fetchUsers() {
        
        UserService.shared.fetchUsers { [weak self] users in
            self?.users = users
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleCancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = configOption == .messages ? "New Message" : "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        if configOption == .messages {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: self,
                                                               action: #selector(handleCancelTapped))
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: - UITableViewDatasource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]

        let profileVC = ProfileController(user: selectedUser)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}


extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // checking if searchController has text
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        // if searchText is true,
        // "users" array will be filtered by the entered "searchText"
        // and the result will be assigned to filteredUsers list
        filteredUsers = users.filter( {$0.username.contains(searchText)} )
        tableView.reloadData()
    }
}
