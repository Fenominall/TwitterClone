//
//  SignUpController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/11/21.
//

import Foundation
import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.plusPhoto, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let emailContainer = Utilities().inputContainerView(withImage: Constants.mail!, textField: emailTextField)
        return emailContainer
    }()
    
    private lazy var passwordContainerView: UIView = {
        let passwordContainer = Utilities().inputContainerView(withImage: Constants.lock!, textField: passwordTextField)
        return passwordContainer
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let nameContainer = Utilities().inputContainerView(withImage: Constants.person!, textField: fullNameTextField)
        return nameContainer
    }()
    
    private lazy var usernameContainerView: UIView = {
        let container = Utilities().inputContainerView(withImage: Constants.person!, textField: usernameTextField)
        return container
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = Utilities().customTextField(withPlaceholder: "Email")
        return emailTextField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = Utilities().customTextField(withPlaceholder: "Password")
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let textField = Utilities().customTextField(withPlaceholder: "Full Name")
        return textField
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = Utilities().customTextField(withPlaceholder: "Username")
        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegisterAcctountAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackOfUI: UIStackView = {
        let stackOfUI = UIStackView(arrangedSubviews: [emailContainerView,
                                                       passwordContainerView,
                                                       fullNameContainerView,
                                                       usernameContainerView,
                                                       registrationButton])
        stackOfUI.axis = .vertical
        stackOfUI.spacing = 20
        stackOfUI.distribution = .fillEqually
        return stackOfUI
    }()
    
    private let loginToAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Selectors
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegisterAcctountAction() {
        
    }
    
    @objc func addProfilePhoto() {
        
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(plusButton)
        plusButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusButton.setDimensions(width: 128, height: 128)
        
        view.addSubview(stackOfUI)
        stackOfUI.anchor(top: plusButton.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 32,
                         paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(loginToAccountButton)
        loginToAccountButton.anchor(left: view.leftAnchor,
                                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    right: view.rightAnchor,
                                    paddingLeft: 40, paddingRight: 40)
        
        
    }
    
    
}
