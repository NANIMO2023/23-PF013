//
//  ChattingMessageView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/17.
//

import UIKit
import RxSwift
import RxCocoa

class ChattingMessageView: UIView {

    // MARK: - Properties
    
    private lazy var chattingBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .chattingCellBackgroundGray
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var chattingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    var chattingBackgroundWidthConstraint: NSLayoutConstraint?
    var chattingBackgroundHeight: CGFloat = 0.0
    
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureMessage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - methods or layouts
    
    private func configureMessage() {
        self.addSubview(chattingBackground)
        chattingBackground.addSubview(chattingLabel)
        
        chattingBackground.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, paddingTop: 10, paddingLeading: 12, paddingBottom: 10, paddingTrailing: 12)
        
        chattingLabel.anchor(top: chattingBackground.topAnchor, leading: chattingBackground.leadingAnchor, bottom: chattingBackground.bottomAnchor, trailing: chattingBackground.trailingAnchor, paddingTop: 10, paddingLeading: 12, paddingBottom: 10, paddingTrailing: 12)
        
        chattingBackgroundWidthConstraint = chattingBackground.widthAnchor.constraint(equalToConstant: 0)  // 초기값 0으로 설정
        chattingBackgroundWidthConstraint?.isActive = true
    }
    
    func configure(name: String?){
        chattingLabel.text = name

        let padding: CGFloat = 24 // 양쪽 패딩 합
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 24
        chattingLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 24

        let width = chattingLabel.intrinsicContentSize.width + padding
        let labelHeight = chattingLabel.intrinsicContentSize.height
        let totalPadding: CGFloat = 20  // 상하 여백의 합
        let expectedBackgroundHeight = labelHeight + totalPadding
        
        chattingBackgroundWidthConstraint?.constant = min(width, maxWidth)
        self.layoutIfNeeded()
        
        chattingBackgroundHeight = CGFloat(Int(expectedBackgroundHeight + 20))
    }
}
