//
//  UIColor+Hex.swift
//  ProjectSense
//
//  Created by Andriy on 10/20/16.
//  Copyright © 2016 Kevin Jiang. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
