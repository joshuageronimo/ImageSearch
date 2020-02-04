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
    let mainStackView = UIStackView(space: 20,
                                    distribution: .fill,
                                    alignment: .center)
    
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
                            fontSize: 14,
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
                            fontSize: 16,
                            fontWeight: .thin,
                            dynamicSize: true,
                            numberOfLines: 10,
                            textAlignment: .center)
        let attributedText = NSMutableAttributedString(string: "by", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
        attributedText.append(NSAttributedString(string: " Photographer", attributes: [:]))
        label.attributedText = attributedText
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(image: UIImage(named: "dismiss-button")!)
        button.addTarget(self, action: #selector(handleDismissButton(sender:)), for: .touchUpInside)
        return button
    }()
    
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
                    let attributedText = NSMutableAttributedString(string: "taken in", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
                    attributedText.append(NSAttributedString(string: " \(location)", attributes: [:]))
                    photoLocationLabel.attributedText = attributedText
                } else {
                    photoLocationLabel.isHidden = true
                }
                
                if let photographer = imageInfo.photographer {
                    let attributedText = NSMutableAttributedString(string: "by", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
                    attributedText.append(NSAttributedString(string: " \(photographer)", attributes: [:]))
                    photoPhotographerLabel.attributedText = attributedText
                } else {
                    photoPhotographerLabel.text = "Unknown photographer"
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
    
    // MARK: ACTIONS
    
    @objc func handleDismissButton(sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: USER INTERFACE
    
    fileprivate func setLayoutConstraints() {
        let screenWidth = self.view.frame.width
        var thumbnailSizeMultiplier: CGFloat = 0.6
        
        // set mainStackView
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
        switch deviceDetection.getDeviceClass() {
        case "iPhone 7, 6 or 6S", "iPhone 5 or 5S or 5C":
            thumbnailSizeMultiplier = 0.6
        default:
            thumbnailSizeMultiplier = 0.65
        }
        photoThumbnailImageView.anchor(width: screenWidth * thumbnailSizeMultiplier, height: screenWidth * thumbnailSizeMultiplier)
        border1.anchor(width: screenWidth * 0.8, height: 2)
        border2.anchor(width: screenWidth * 0.8, height: 2)
        photoLocationLabel.anchor(width: screenWidth, height: 20)
        photoPhotographerLabel.anchor(width: screenWidth, height: 25)
        
        mainStackView.addArrangedSubview(SpacerView(space: 5))
        mainStackView.addArrangedSubview(photoThumbnailImageView)
        mainStackView.addArrangedSubview(photoTitleLabel)
        mainStackView.addArrangedSubview(border1)
        mainStackView.addArrangedSubview(photoDescriptionLabel)
        mainStackView.addArrangedSubview(border2)
        mainStackView.addArrangedSubview(photoLocationLabel)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(photoPhotographerLabel)
        
        // set dismissbutton constraints
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor,
                             left: nil,
                             right: view.trailingAnchor,
                             bottom: nil,
                             topPadding: 15,
                             leftPadding: 0,
                             rightPadding: -30,
                             bottomPadding: 0,
                             width: 25,
                             height: 25)
        
        
    }
}
