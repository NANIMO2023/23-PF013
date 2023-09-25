//
//  Color+Extension.swift
//  Nanimo
//
//  Created by Lena on 2023/07/12.
//

import UIKit.UIColor
import SwiftUI

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
    
    static var chattingCellBackgroundGray: UIColor {
        return UIColor(rgb: 0xF6F6F5)
    }
    
    static var placeHolderGray: UIColor {
        return UIColor(rgb: 0x979797)
    }
}

extension Color {
    static var carColor: Color {
        return Color(red: 255/255.0, green: 184/255.0, blue: 0.0)
//        return Color(red: 255/255.0, green: 184/255.0, blue: 0.0, opacity: 0.25)
    }
    
    static var thingColor: Color {
        return Color(red: 62/255.0, green: 162/255.0, blue: 255/255.0)
//        return Color(red: 62/255.0, green: 162/255.0, blue: 255/255.0, opacity: 0.25)
    }
    
    static var dogColor: Color {
        return Color(red: 196/255.0, green: 241/255.0, blue: 169/255.0)
//        return Color(red: 250/255.0, green: 90/255.0, blue: 90/255.0, opacity: 0.16)
    }
    
    static var babyColor: Color {
        return Color(red: 250/255.0, green: 90/255.0, blue: 40/255.0)
//        return Color(red: 250/255.0, green: 90/255.0, blue: 40/255.0, opacity: 0.16)
    }
}
