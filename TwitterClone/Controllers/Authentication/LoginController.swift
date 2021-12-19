//
//  LoginController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/11/21.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        logoImageView.image = Constants.twitterLogo
        return logoImageView
    }()
    
    private lazy var emailContainerView: UIView = {
        let emailContainer = Utilities().inputContainerView(withImage: Constants.mailImage!, textField: emailTextField)
        return emailContainer
    }()
    
    private lazy var passwordContainerView: UIView = {
        let passwordContainer = Utilities().inputContainerView(withImage: Constants.lockImage!, textField: passwordTextField)
        return passwordContainer
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Don`t have account?", " Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackOfUI: UIStackView = {
        let stackOfUI = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackOfUI.axis = .vertical
        stackOfUI.spacing = 20
        stackOfUI.distribution = .fillEqually
        return stackOfUI
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Selectors
    @objc func handleLogin() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error logging in \(error.localizedDescription)")
                return
            }
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tabController = window.rootViewController as? MainTabController else { return }
            tabController.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp() {
        let regController = RegistrationController()
        navigationController?.pushViewController(regController, animated: true)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        view.addSubview(stackOfUI)
        stackOfUI.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingLeft: 40, paddingRight: 40)
    }
    
    
    
}
