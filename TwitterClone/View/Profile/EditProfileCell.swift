//
//  ProfileCell.swift
//  TwitterClone
//
//  Created by Fenominall on 1/19/22.
//

import UIKit

class EditProfileCell: UITableViewCell {
    // MARK: - Properties
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
}
