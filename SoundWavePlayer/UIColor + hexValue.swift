//
//  UIColor + hexValue.swift
//  SoundWavePlayer
//
//  Created by Максим Спиридонов on 07.06.2020.
//  Copyright © 2020 Максим Спиридонов. All rights reserved.
//

import UIKit.UIColor

//MARK: - UIColor random function and hexValue
extension UIColor {
    convenience init? (hexValue: String, alpha: CGFloat) {
        if hexValue.hasPrefix("#") {
            let scanner = Scanner(string: hexValue)
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
            
            var hexInt64: UInt64 = 0
            if hexValue.count == 7 {
                if scanner.scanHexInt64(&hexInt64) {
                    let red = CGFloat((hexInt64 & 0xFF0000) >> 16) / 255
                    let green = CGFloat((hexInt64 & 0x00FF00) >> 8) / 255
                    let blue = CGFloat(hexInt64 & 0x0000FF) / 255
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        return nil
    }
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
