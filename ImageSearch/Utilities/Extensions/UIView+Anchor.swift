//
//  UIView+Anchor.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/2/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

// This UIView extension has functions that makes it easier to handle UI Constraints programmatically.
extension UIView {
    
    /// Constraints UIObjects to top, right, bottom, & left anchors.
    ///
    /// - Parameters:
    ///   - top: topAnchor
    ///   - right: trailingAnchor
    ///   - bottom: bottomAnchor
    ///   - left: leadingAnchor
    ///   - topPadding: topAnchor's constant
    ///   - rightPadding: trailing's constant
    ///   - bottomPadding: bottomPadding's constant
    ///   - leftPadding: leadingPadding's constant
    ///   - width: size of the width using CGFloat (enter "0" if you dont need to specify)
    ///   - height: size of the height using CGFloat (enter "0" if you dont need to specify)
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, topPadding: CGFloat, leftPadding: CGFloat, rightPadding: CGFloat, bottomPadding: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: rightPadding).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomPadding).isActive = true
        }
        
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    // Can anchor width & height with a constant using CGFloat
    func anchor(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    /// Can anchor width & height with multiplier
    ///
    /// - Parameters:
    ///   - viewWidth: the screen's width.
    ///   - viewHeight: the screen's height.
    ///   - amount: how much width or height needs to be multiplied by.
    func anchor(viewWidth: NSLayoutDimension?, viewHeight: NSLayoutDimension?, multipier amount: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if amount > 0 {
            if let viewWidth = viewWidth {
                widthAnchor.constraint(equalTo: viewWidth, multiplier: amount).isActive = true
            }
            
            if let viewHeight = viewHeight {
                heightAnchor.constraint(equalTo: viewHeight, multiplier: amount).isActive = true
            }
        } else {
            if let viewWidth = viewWidth {
                widthAnchor.constraint(equalTo: viewWidth).isActive = true
            }
            
            if let viewHeight = viewHeight {
                heightAnchor.constraint(equalTo: viewHeight).isActive = true
            }
        }
    }
    
    /// Can anchor layout using X & Y axis anchors
    ///
    /// - Parameters:
    ///   - centerX: X Axis Anchor of the screen
    ///   - centerY: Y Axis Anchor of the screen
    func anchor(centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}
