//
//  PhotoCell.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/1/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: CustomImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCellInfo(photo: Photo) {
        loadingIndicator.startAnimating()
        if let photoLink = photo.getImageLink() {
            self.photo.loadImageUsingUrlString(urlString: photoLink) { [weak self] (status: PhotoLoadingStatus) in
                switch status {
                case .success:
                    self?.loadingIndicator.stopAnimating()
                case .failed:
                    self?.loadingIndicator.stopAnimating()
                }
            }
        } else {
            loadingIndicator.stopAnimating()
        }
    }

}
