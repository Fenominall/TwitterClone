//
//  UIButtonConfigurationExtension.swift
//  TwitterClone
//
//  Created by Fenominall on 12/10/21.
//

import Foundation
import UIKit

extension UIButton.Configuration {
    
    static func blueStickyButton() -> UIButton.Configuration {
        var configuration: UIButton.Configuration = .filled()
        configuration.baseBackgroundColor = .twitterBlue
        configuration.baseForegroundColor = .white
        configuration.image = Constants.newTweet
        return configuration
    }
    
    
}
