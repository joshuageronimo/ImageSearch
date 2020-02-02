//
//  UIColor+Theme.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/2/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    static let mainColor = UIColor.black
    static let secondaryColor = UIColor.white
}
