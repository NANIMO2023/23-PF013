//
//  Label+Extension.swift
//  Nanimo
//
//  Created by Lena on 2023/07/27.
//

import UIKit

extension UILabel {
    
    func setLabel(labelText: String, backgroundColor: UIColor, weight: UIFont.Weight, textSize: Int, labelColor: UIColor) {
        self.text = labelText
        self.backgroundColor = backgroundColor
        self.font = .systemFont(ofSize: CGFloat(textSize), weight: weight)
        self.textColor = labelColor
    }
    
    func setSpacingLabel(text: String, spacing: Int, labelColor: UIColor, weight: UIFont.Weight, textSize: Int) {
        let calculatedSpacing: Double = Double(textSize * spacing) * 0.01
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: calculatedSpacing, range: NSRange(location: 0, length: text.count - 1))
        
        self.attributedText = attributedString
    }
}
