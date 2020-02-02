//
//  CustomImageView.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/1/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//


import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

enum PhotoLoadingStatus {
    case failed
    case success
}

// This custom UIImageView class will load images from the internet and cache the image.
class CustomImageView: UIImageView {
    
    var imageUrlString: String? /* reference of the current URL */
    
    func loadImageUsingUrlString(urlString: String, completion: @escaping (PhotoLoadingStatus) -> ()) {
        imageUrlString = urlString
        guard let url = URL(string: urlString) else {
            completion(.failed)
            return
        }
        image = UIImage(named: "default-gallery-image") /* set deafult image while waiting for image to load */
        
        // If the image is in the imageCache already, use that image to avoid reloading of data.
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            completion(.success)
            return
        }
        
        // Get the Photo!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in DispatchQueue.main.async {
            guard let imageData = data else { return }
            guard let imageToCache = UIImage(data: imageData) else { return }
            // Check if the image is going to be loaded in the right cell.
            if self.imageUrlString == urlString {
                completion(.success)
                self.image = imageToCache
            }
            // cache the image
            completion(.success)
            imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
            }}).resume()
    }
}
