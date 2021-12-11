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
        let emailContainer = Utilities().inputContainerView(withImage: Constants.mail!, textField: emailTextField)        
        return emailContainer
    }()
    
    private lazy var passwordContainerView: UIView = {
        let passwordContainer = Utilities().inputContainerView(withImage: Constants.lock!, textField: passwordTextField)
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
    
    
    private lazy var stackOfUI: UIStackView = {
        let stackOfUI = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stackOfUI.axis = .vertical
        stackOfUI.spacing = 8
        return stackOfUI
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Selectors
    
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
                         paddingLeft: 20, paddingRight: 20)
    }
    
    
    
}
