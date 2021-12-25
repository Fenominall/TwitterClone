//
//  ImageService.swift
//  TwitterClone
//
//  Created by Fenominall on 12/25/21.
//

import UIKit


struct ImageService {
    static let shared = ImageService()
    // Asynchronous func to download image from Firebase "RealTime Database" for user profile image
    func downloadAndSetImage(with url: URL?, for imageView: UIImageView) {
        guard let url = url else { return }
        
        let downloadImageTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DEBUG: profileImageUrl is \(error) ")
            }
            if let imageData = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: imageData)
                }
            }
        }
        downloadImageTask.resume()
    }
}
