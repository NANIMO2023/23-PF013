//
//  BulletLabel.swift
//  Nanimo
//
//  Created by Lena on 2023/07/27.
//

import UIKit

class BulletView: UIView {
    
    private var bulletLabel = UILabel()
    private var audioLabel = UILabel()
    private var numberLabel = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabels(soundName: String, soundNumber: Int, backgroundColor: UIColor ,labelColor: UIColor) {
        
        audioLabel.setLabel(labelText: " \(soundName) ", backgroundColor: backgroundColor, weight: .regular, textSize: 18, labelColor: labelColor)
        audioLabel.backgroundColor?.withAlphaComponent(0.5)
        numberLabel.setLabel(labelText: " X \(soundNumber)회", backgroundColor: .clear, weight: .regular, textSize: 18, labelColor: .detailTextGrayButton)
    }
    
    func configureLayout() {
        backgroundColor = .clear
        bulletLabel.setLabel(labelText: "●", backgroundColor: .clear, weight: .regular, textSize: 10, labelColor: .bulletGray)
        
        [bulletLabel, audioLabel, numberLabel].forEach { addSubview($0) }
        [bulletLabel, audioLabel, numberLabel].forEach { $0.centerY(inView: self) }
        
        self.setHeight(height: 31)
        bulletLabel.anchor(leading: self.leadingAnchor, paddingLeading: 8)
        audioLabel.anchor(leading: bulletLabel.trailingAnchor, paddingLeading: 8)
        numberLabel.anchor(leading: audioLabel.trailingAnchor, paddingLeading: 8)
        
    }
    
}
