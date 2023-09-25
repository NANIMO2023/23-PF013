//
//  lastMessageView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/09/18.
//

import UIKit
import RxSwift

class LastMessageView: UIView {

    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3.0
        return view
    }()
    
    private lazy var lastMessageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true // 라운드 처리된 경계 내부로 내용을 클리핑하기 위해 true로 설정
        
        // 테두리 설정
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor

        return view
    }()
    
    lazy var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    var lastMessageBackgroundViewWidthConstraint: NSLayoutConstraint?
    var lastMessageBackgroundViewHeight: CGFloat = 0.0
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        configureLastMessage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLastMessage() {
        self.addSubview(shadowView)
        shadowView.addSubview(lastMessageBackgroundView)
        lastMessageBackgroundView.addSubview(lastMessageLabel)
        
        shadowView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, paddingTop: 10, paddingLeading: 12, paddingBottom: 10, paddingTrailing: 12)
            
        lastMessageBackgroundView.anchor(top: shadowView.topAnchor, leading: shadowView.leadingAnchor, bottom: shadowView.bottomAnchor, trailing: shadowView.trailingAnchor)
        
        lastMessageLabel.anchor(top: lastMessageBackgroundView.topAnchor, leading: lastMessageBackgroundView.leadingAnchor, bottom: lastMessageBackgroundView.bottomAnchor, trailing: lastMessageBackgroundView.trailingAnchor, paddingTop: 8, paddingLeading: 12, paddingBottom: 8, paddingTrailing: 12)
        
        lastMessageBackgroundViewWidthConstraint = lastMessageBackgroundView.widthAnchor.constraint(equalToConstant: 0)  // 초기값 0으로 설정
        lastMessageBackgroundViewWidthConstraint?.isActive = true
    }
    
    func configure(name: String?){
        lastMessageLabel.text = name

        let padding: CGFloat = 24 // 양쪽 패딩 합
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 24
        lastMessageLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 24

        let width = lastMessageLabel.intrinsicContentSize.width + padding
        let labelHeight = lastMessageLabel.intrinsicContentSize.height
        let totalPadding: CGFloat = 20  // 상하 여백의 합
        let expectedBackgroundHeight = labelHeight + totalPadding
        
        lastMessageBackgroundViewWidthConstraint?.constant = min(width, maxWidth)
        self.layoutIfNeeded()
        
        lastMessageBackgroundViewHeight = CGFloat(Int(expectedBackgroundHeight + 20))
    }
}
