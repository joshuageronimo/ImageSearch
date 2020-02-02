//
//  UIObject+Convenience.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/2/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}

extension UILabel {
    convenience init(text: String, textColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight, dynamicSize: Bool = false, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .center) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.adjustsFontSizeToFitWidth = dynamicSize
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.minimumScaleFactor = 0.5
    }
}

extension UIImageView {
    convenience init(image: UIImage, contentMode: UIView.ContentMode, tintColor: UIColor? = nil) {
        self.init(image: image)
        if let tintColor = tintColor {
           self.tintColor = tintColor
        }
        self.contentMode = .scaleAspectFit
    }
}
