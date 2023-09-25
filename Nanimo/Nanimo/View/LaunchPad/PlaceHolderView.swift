//
//  PlaceHolderView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/09/18.
//

import UIKit

class PlaceHolderView: UIView {
    
    lazy var largeTitleLabel = UILabel()
    
    lazy var subTitleLabel = {
        let label = UILabel()
        label.text = """
        당신의 말을 글로 받아 적어
        청각장애인과의 대화를 돕는 앱, 듣는이입니다
        대화 내용은 10분동안 유지되며,
        명시된 용도 이외에는 사용되지 않습니다
        """
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .placeHolderGray
        return label
    }()

    init() {
        super.init(frame: .zero)
        
        largeTitleLabel.setLabel(labelText: "안녕하세요", backgroundColor: .clear, weight: .black, textSize: 32, labelColor: .placeHolderGray)
        
        configurePlaceHolder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePlaceHolder() {
        [largeTitleLabel, subTitleLabel].forEach {
            self.addSubview($0)
        }

        largeTitleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.subTitleLabel.topAnchor, trailing: self.trailingAnchor, paddingBottom: 6, height: 38)
        
        subTitleLabel.anchor(leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, height: 96)
    }
}
