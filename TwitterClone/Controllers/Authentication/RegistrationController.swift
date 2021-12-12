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
        button.setImage(Constants.plusPhoto, for: .normal)
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
              let username = usernameTextField.text else { return }
        print("You are here with \(email) and \(password)")
        
        // Converting an uploaded image into data and
        // compressing an image quality
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        // Generating unique UUID for each uploaded image
        let fileName = NSUUID().uuidString
        // Referencing the place for created storage
        let storageRef = STORAGE_PROFILE_IMAGES.child(fileName)
        // Uploading image data to the provided storage reference
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            print("data put")
            // Getting downloaded url for an image, storage url is gonna be stored in the database structure
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {
                    print("URL is missing \(String(describing: error))")
                    return }
                print("Got url")
                
                // Firebase authentication creating a user
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG THE ERROR: \(error.localizedDescription)")
                        return
                    }
                    // UID asks to come data back for the result in Auth call
                    guard let uid = result?.user.uid else { return }
                    // Dictionary with values to register the user
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullName,
                                  "profileImageUrl": profileImageUrl]
                    
                    // Creating database structure for user profile
                    REF_USERS.child(uid).updateChildValues(values) { (error, reference) in
                        print("DEBUG: Successfully updated user information...")
                    }
                }
            }
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
