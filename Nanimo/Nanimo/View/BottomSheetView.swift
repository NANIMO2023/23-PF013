//
//  BottomSheetViewController.swift
//  Nanimo
//
//  Created by Lena on 2023/09/16.
//

import UIKit

class BottomSheetView: UIView {
    
    private var talkLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트와 SFSymbol을 조합한 NSAttributedString을 만듭니다.
        let symbolName1 = "wave.3.left"
        let symbolImage1 = UIImage(systemName: symbolName1)
        let symbolAttachment1 = NSTextAttachment()
        symbolAttachment1.image = symbolImage1
        let symbolAttributedString1 = NSAttributedString(attachment: symbolAttachment1)
        
        let symbolName2 = "wave.3.right"
        let symbolImage2 = UIImage(systemName: symbolName2)
        let symbolAttachment2 = NSTextAttachment()
        symbolAttachment2.image = symbolImage2
        let symbolAttributedString2 = NSAttributedString(attachment: symbolAttachment2)
        
        let labelText = " 탭해서 말하기 "
        let textAttributedString = NSAttributedString(string: labelText)
        
        // 앞뒤로 SFSymbol을 넣은 NSAttributedString을 만듭니다.
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(symbolAttributedString1)
        combinedAttributedString.append(textAttributedString)
        combinedAttributedString.append(symbolAttributedString2) // 텍스트 뒤에도 SFSymbol 추가
        
        label.attributedText = combinedAttributedString
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
       
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.layer.cornerRadius = 12
        self.addSubview(talkLabel)
        
        self.backgroundColor = .white
        self.customShadow(color: .lightGray, width: 0, height: -3, opacity: 0.3, radius: 15)
        
        talkLabel.centerX(inView: self)
        talkLabel.centerY(inView: self)
        talkLabel.setHeight(height: 36)
    }
}
