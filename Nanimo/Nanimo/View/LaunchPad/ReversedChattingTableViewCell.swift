//
//  ReverseTableViewCell.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/09/11.
//

import UIKit
import RxSwift
import RxCocoa

class ReversedChattingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reverseChattingCellId = "ReverseChattingCellId"
    
//    var viewModel: ChattingViewModel? {
//        didSet {
//            bindViewModel()
//        }
//    }
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3.0
        return view
    }()
    
    private lazy var chattingBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true // 라운드 처리된 경계 내부로 내용을 클리핑하기 위해 true로 설정
        
        // 테두리 설정
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor

        return view
    }()
    
    lazy var chattingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var micImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "waveform.and.mic")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()

    var chattingBackgroundWidthConstraint: NSLayoutConstraint?
    var chattingBackgroundHeight: CGFloat = 0.0
    
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTableCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemneted")
    }
    
    // MARK: - methods for layouts
    
    private func configureTableCell() {
        self.addSubview(shadowView)
        shadowView.addSubview(chattingBackgroundView)
        chattingBackgroundView.addSubview(chattingLabel)
        chattingBackgroundView.addSubview(micImageView)
        
        shadowView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, paddingTop: 10, paddingLeading: 12, paddingBottom: 10, paddingTrailing: 12)
            
        chattingBackgroundView.anchor(top: shadowView.topAnchor, leading: shadowView.leadingAnchor, bottom: shadowView.bottomAnchor, trailing: shadowView.trailingAnchor)
        
        micImageView.anchor(top: chattingBackgroundView.topAnchor, leading: chattingBackgroundView.leadingAnchor, bottom: chattingBackgroundView.bottomAnchor, trailing: chattingLabel.leadingAnchor, paddingTop: 8, paddingLeading: 12, paddingBottom: 8, paddingTrailing: 8, width: 21, height: 21)
        
        chattingLabel.anchor(top: chattingBackgroundView.topAnchor, leading: micImageView.trailingAnchor, bottom: chattingBackgroundView.bottomAnchor, trailing: chattingBackgroundView.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingTrailing: 12)
        
        chattingBackgroundWidthConstraint = chattingBackgroundView.widthAnchor.constraint(equalToConstant: 0)  // 초기값 0으로 설정
        chattingBackgroundWidthConstraint?.isActive = true
    }
 
    func configure(name: String?){
        chattingLabel.text = name

        let padding: CGFloat = 24 // 양쪽 패딩 합
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 24
        chattingLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 24

        let width = chattingLabel.intrinsicContentSize.width + padding + micImageView.intrinsicContentSize.width + 12
        let labelHeight = chattingLabel.intrinsicContentSize.height
        let totalPadding: CGFloat = 20  // 상하 여백의 합
        let expectedBackgroundHeight = labelHeight + totalPadding
        
        chattingBackgroundWidthConstraint?.constant = min(width, maxWidth)
        self.layoutIfNeeded()
        
        chattingBackgroundHeight = CGFloat(Int(expectedBackgroundHeight + 20))
    }
    
//    private func bindViewModel() {
//        viewModel?.isInputCompletedRelay
//            .asObservable()
//            .distinctUntilChanged() // 이전 값과 동일한 값의 연속적인 이벤트는 필터링합니다.
////            .filter { $0 == true }  // true 값만을 필터링합니다.
//            .subscribe(onNext: { [weak self] result in
//                self?.chattingBackgroundView.backgroundColor = result ? .black : .white
//                self?.chattingLabel.textColor = result ? .white : .black
//            })
////            .bind(onNext: { [weak self] completed in
////                print("TableViewCell : ", completed)
////                self?.chattingBackgroundView.backgroundColor = completed ? .black : .white
////                self?.chattingLabel.textColor = completed ? .white : .black
////            })
////            .disposed(by: disposeBag)
//    }
    
    func updateDesign(isFinalized: Bool) {
        micImageView.isHidden = true
        let padding: CGFloat = 24 // 양쪽 패딩 합
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 24
        let width = chattingLabel.intrinsicContentSize.width + padding
        
        chattingBackgroundWidthConstraint?.constant = min(width, maxWidth)
        
        chattingLabel.anchor(top: chattingBackgroundView.topAnchor, leading: chattingBackgroundView.leadingAnchor, bottom: chattingBackgroundView.bottomAnchor, trailing: chattingBackgroundView.trailingAnchor, paddingTop: 8, paddingLeading: 12, paddingBottom: 8, paddingTrailing: 12)
        
        self.layoutIfNeeded()
        
        self.chattingBackgroundView.backgroundColor = isFinalized ? .black : .white
        self.chattingLabel.textColor = isFinalized ? .white : .black
    }
}
