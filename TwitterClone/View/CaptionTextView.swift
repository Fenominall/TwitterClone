//
//  CaptionTextField.swift
//  TwitterClone
//
//  Created by Fenominall on 12/19/21.
//

import UIKit

class CaptionTextView: UITextView {
    // MARK: - Properties
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What`s happening here?"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor,
                                left: leftAnchor,
                                paddingTop: 8, paddingLeft: 4)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    // Observing changed in CaptionTextView, if text appears in CaptionTextView,
    // then placeHolderLabel becomes hidden
    @objc func handleTextInputChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
}
