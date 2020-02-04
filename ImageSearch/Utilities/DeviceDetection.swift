//
//  DeviceDetection.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/3/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

struct DeviceDetection{
    func getDeviceClass()-> String{
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return "iPhone 5 or 5S or 5C"
            case 1334:
                return "iPhone 7, 6 or 6S"
            case 1920, 2208:
                return "iPhone 6+/6S+/7+/8+"
            case 2436:
                return "iPhone X, or XS"

            case 2688:
                return "iPhone XS Max"

            case 1792:
                return "iPhone XR"
            default:
                return "unknown iPhone, measurements: Height: \(UIScreen.main.nativeBounds.height), Width: \(UIScreen.main.nativeBounds.width)"
            }
        }else if UIDevice().userInterfaceIdiom == .pad{
            return "ipad"
        }else{
            return "unknown device, not iPad or iPhone, measurements: Height: \(UIScreen.main.nativeBounds.height), Width: \(UIScreen.main.nativeBounds.width)"
        }
    }
}

// Make globally accessible
let deviceDetection = DeviceDetection()
