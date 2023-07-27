//
//  Color+Extension.swift
//  Nanimo
//
//  Created by Lena on 2023/07/12.
//

import UIKit.UIColor

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}

extension UIColor {
    static var customChartGreen: UIColor {
        return UIColor(rgb: 0xA2EE00)
    }
    
    static var customBackgroundGreen: UIColor {
        return UIColor(rgb: 0xC4F1A9)
    }
    
    static var customGreen: UIColor {
        return UIColor(rgb: 0x47B802)
    }
    
    static var detailBackgroundGrayButton: UIColor {
        return UIColor(rgb: 0xD9D9D9)
    }
    
    static var detailTextGrayButton: UIColor {
        return UIColor(rgb: 0x1E1E1E)
    }
    
    static var bulletGray: UIColor {
        return UIColor(rgb: 0x777777)
    }
}
