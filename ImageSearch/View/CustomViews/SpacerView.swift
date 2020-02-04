//
//  SpacerView.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/3/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

/// This custom view is to make it easier to create a spacer view for stackviews
class SpacerView: UIView {
    
    fileprivate let space: CGFloat
    
    override var intrinsicContentSize: CGSize {
        return .init(width: space, height: space)
    }
    
    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
