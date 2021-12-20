//
//  SignUpController.swift
//  TwitterClone
//
//  Created by Fenominall on 12/11/21.
//

import Foundation
import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    
    // Picking an image for userProfile
    private lazy var imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    // UIViews
    private lazy var emailContainerView: UIView = {
        let emailContainer = Utilities().inputContainerView(withImage: Constants.mailImage!, textField: emailTextField)
        return emailContainer
    }()
    
    private lazy var passwordContainerView: UIView = {
        let passwordContainer = Utilities().inputContainerView(withImage: Constants.lockImage!, textField: passwordTextField)
        return passwordContainer
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let nameContainer = Utilities().inputContainerView(withImage: Constants.personImage!, textField: fullNameTextField)
        return nameContainer
    }()
    
    private lazy var usernameContainerView: UIView = {
        let container = Utilities().inputContainerView(withImage: Constants.personImage!, textField: usernameTextField)
        return container
    }()
    
    // TextFields
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
    
    // Buttons
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.plusPhotoImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegisterAccountAction), for: .touchUpInside)
        return button
    }()
    
    private let loginToAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    // Stack of all configured UIElements on the Registration Screen
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Selectors
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegisterAccountAction() {
        // Getting data from the user`s input
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image...")
            return
        }
        guard let email = emailTextField.text?.lowercased(),
              let password = passwordTextField.text,
              let fullName = fullNameTextField.text,
              let username = usernameTextField.text?.lowercased() else { return }
        
        let userCredentials = AuthCredentials(email: email,
                                              password: password,
                                              fullName: fullName,
                                              username: username,
                                              profileImage: profileImage)
        // Registering the user to Firebase with input credentials
        AuthService.shared.registerUser(credentials: userCredentials) { (error, reference) in
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tabController = window.rootViewController as? MainTabController else { return }
            tabController.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func addProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
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

extension RegistrationController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageProvider = info[.editedImage] as? UIImage else { return }
        self.plusButton.setImage(imageProvider.withRenderingMode(.alwaysOriginal),
                                 for: .normal)
        // assigning profile image
        self.profileImage = imageProvider
        
        // Picked Image configurations
        plusButton.layer.cornerRadius = 128 / 2
        plusButton.layer.masksToBounds = true
        plusButton.imageView?.clipsToBounds = true
        plusButton.imageView?.contentMode = .scaleAspectFill
        plusButton.layer.borderWidth = 3
        plusButton.layer.borderColor = UIColor.white.cgColor
        
        dismiss(animated: true, completion: nil)
    }
}
