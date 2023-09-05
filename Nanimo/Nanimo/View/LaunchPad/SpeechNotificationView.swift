//
//  SpeechNotificationView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit
import RxSwift
import RxCocoa

class SpeechNotificationView: UIView {

    let viewModel: SpeechViewModel
    
    lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let notificationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Notification")
        imageView.sizeToFit()
        return imageView
    }()
    
    var disposeBag = DisposeBag()
    
    
    init(viewModel: SpeechViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureNotification()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNotification() {
        self.addSubview(notificationImage)
        notificationImage.addSubview(notificationLabel)
        
        notificationImage.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, height: 43)
        
        notificationLabel.anchor(top: notificationImage.topAnchor, bottom: notificationImage.bottomAnchor, paddingTop: 6, paddingBottom: 16)
        notificationLabel.centerX(inView: notificationImage)
    }
}

extension SpeechNotificationView {
    func bind() {
        viewModel.modeSubject
            .subscribe(onNext: { [weak self] mode in
                self?.updateLabelText(for: mode)
            })
            .disposed(by: disposeBag)
    }
    
    func updateLabelText(for mode: SpeechMode) {
        let attributedText: NSMutableAttributedString
        let boldText: String
        
        switch mode {
        case .speech:
            boldText = "켜져"
            attributedText = NSMutableAttributedString(string: "“스피커를 통해 말하기”기능이 켜져 있어요")
            self.fadeIn(duration: 3)
            self.fadeOut(duration: 3)
        case .notspeech:
            boldText = "꺼져"
            attributedText = NSMutableAttributedString(string: "“스피커를 통해 말하기”기능이 꺼져 있어요")
            self.fadeIn(duration: 3)
            self.fadeOut(duration: 3)
        }
        
        let range = (attributedText.string as NSString).range(of: boldText)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        
        attributedText.addAttributes(attributes, range: range)
        notificationLabel.attributedText = attributedText
    }
}
