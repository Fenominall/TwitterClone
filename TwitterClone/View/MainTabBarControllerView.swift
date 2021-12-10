////
////  MainTabBarControllerView.swift
////  TwitterClone
////
////  Created by Fenominall on 12/10/21.
////
//
//import Foundation
//import UIKit
//
//class MainTabBarControllerView: UIView {
//
//    // MARK: - Properties
//
//    private lazy var container: UIView = {
//        let container = UIView(frame: .zero)
//        container.translatesAutoresizingMaskIntoConstraints = false
//        return container
//    }()
//
//    private(set) lazy var actionButton: UIButton = {
//        let actionButton = UIButton(type: .system)
//        actionButton.configuration = .blueStickyButton()
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.layer.cornerRadius = 56 / 2
////        actionButton.addTarget(self, action: <#T##Selector#>, for: .touchUpInside)
//        return actionButton
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//}
//
//extension MainTabBarControllerView {
//    private func configureUI() {
//        backgroundColor = .white
//
//        addSubview(container)
//        container.addSubview(actionButton)
//
//        NSLayoutConstraint.activate([
//            container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            container.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
//            container.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            container.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
//
//            actionButton.heightAnchor.constraint(equalToConstant: 56),
//            actionButton.widthAnchor.constraint(equalToConstant: 56),
//            actionButton.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -50),
//            actionButton.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//
//        ])
//
//
//    }
//}
//
//
//
