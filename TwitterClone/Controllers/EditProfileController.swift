//
//  EditProfileController.swift
//  TwitterClone
//
//  Created by Fenominall on 1/19/22.
//

import UIKit

class EditProfileController: UITableViewController {
    // MARK: - Properties
    private let user: User
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSaveData() {
        
    }
    // MARK: - API
    // MARK: - Helpers
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white

        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSaveData))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

}
