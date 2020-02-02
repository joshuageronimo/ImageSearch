//
//  PhotoDetailController.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/2/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

class PhotoDetailController: UIViewController {
    
    // MARK: UIOBJECTS
    let photoThumbnailImageView = CustomImageView(image: UIImage(named: "default-gallery-image")!,
                                     contentMode: .scaleAspectFill)
    
    let photoTitleLabel = UILabel(text: "Title",
                                  textColor: .secondaryColor,
                                  fontSize: 20,
                                  fontWeight: .bold,
                                  dynamicSize: true,
                                  numberOfLines: 1,
                                  textAlignment: .center)
    
    let border1 = UIView(backgroundColor: .secondaryColor)
    
    let photoDescriptionLabel = UILabel(text: "Description",
                                        textColor: .secondaryColor,
                                        fontSize: 15,
                                        fontWeight: .thin,
                                        dynamicSize: true,
                                        numberOfLines: 0,
                                        textAlignment: .center)
    
    let border2 = UIView(backgroundColor: .secondaryColor)
    
    let photoLocationLabel: UILabel = {
        let label = UILabel(text: "",
                            textColor: .secondaryColor,
                            fontSize: 15,
                            fontWeight: .thin,
                            dynamicSize: true,
                            numberOfLines: 0,
                            textAlignment: .center)
        let attributedText = NSMutableAttributedString(string: "taken in", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        attributedText.append(NSAttributedString(string: " Location", attributes: [:]))
        label.attributedText = attributedText
        return label
    }()
    
    let photoPhotographerLabel: UILabel = {
        let label = UILabel(text: "",
                            textColor: .secondaryColor,
                            fontSize: 15,
                            fontWeight: .thin,
                            dynamicSize: true,
                            numberOfLines: 0,
                            textAlignment: .center)
        let attributedText = NSMutableAttributedString(string: "by", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        attributedText.append(NSAttributedString(string: " Photographer", attributes: [:]))
        label.attributedText = attributedText
        return label
    }()
    
    let mainStackView = UIStackView(space: 20,
                                    distribution: .fill,
                                    alignment: .center)
    
    var photo: Photo? {
        didSet {
            if let photo = photo,
                let imageInfo = photo.getImageInfo() {
                
                photoThumbnailImageView.loadImageUsingUrlString(urlString: photo.getImageLink() ?? "") { (status: PhotoLoadingStatus) in
                    switch status {
                    case .failed:
                        print("failed")
                    case .success:
                        print("success")
                    }
                }
                photoTitleLabel.text = imageInfo.title ?? "Unknown"
                
                if let description = imageInfo.description {
                    photoDescriptionLabel.text = description
                } else {
                    photoDescriptionLabel.isHidden = true
                    border2.isHidden = true
                }
                
                if let location = imageInfo.location {
                    photoLocationLabel.text = location
                } else {
                    photoLocationLabel.isHidden = true
                }
            }
        }
    }
    
    // MARK: LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

    }
    
    fileprivate func initialSetup() {
        view.backgroundColor = .mainColor
        setLayoutConstraints()
    }
    
    // MARK: USER INTERFACE
    
    fileprivate func setLayoutConstraints() {
        let screenWidth = self.view.frame.width
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             left: view.leadingAnchor,
                             right: view.trailingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             topPadding: 20,
                             leftPadding: 20,
                             rightPadding: -20,
                             bottomPadding: -10,
                             width: 0,
                             height: 0)
        
        photoThumbnailImageView.anchor(width: screenWidth * 0.65, height: screenWidth * 0.65)
        border1.anchor(width: screenWidth * 0.8, height: 2)
        border2.anchor(width: screenWidth * 0.8, height: 2)
        
        mainStackView.addArrangedSubview(photoThumbnailImageView)
        mainStackView.addArrangedSubview(photoTitleLabel)
        mainStackView.addArrangedSubview(border1)
        mainStackView.addArrangedSubview(photoDescriptionLabel)
        mainStackView.addArrangedSubview(border2)
        mainStackView.addArrangedSubview(photoLocationLabel)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(photoPhotographerLabel)
    }
}
