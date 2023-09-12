//
//  SpeechButtonView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit
import RxSwift

class SpeechButtonView: UIView {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.setSpacingLabel(text: "탭해서 말하기", spacing: 8, labelColor: .black, weight: .medium, textSize: 14)
        return label
    }()
    
    private lazy var notificationImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "SpeechNotification"))
        imageView.transform = CGAffineTransform(scaleX: -1, y: -1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let viewModel: SpeechViewModel
    private let disposeBag = DisposeBag()
    weak var delegate: SpeechButtonViewDelegate?
    
    private var buttonWidthConstraint: NSLayoutConstraint?
    private var buttonHeightConstraint: NSLayoutConstraint?
    
    init(viewModel: SpeechViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bindViewModel()
        configureButtonLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonLabel() {
        [notificationLabel, button, notificationImage].forEach {
            self.addSubview($0)
        }
        notificationImage.centerX(inView: self)
        notificationImage.anchor(top: self.safeAreaLayoutGuide.topAnchor, bottom: button.topAnchor, paddingBottom: 24)
    
        notificationLabel.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.safeAreaLayoutGuide.leadingAnchor, bottom: button.topAnchor, trailing: self.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 5, height: 20)
        
        button.anchor(bottom: self.safeAreaLayoutGuide.bottomAnchor)
        button.centerX(inView: self)
        
        buttonWidthConstraint = button.widthAnchor.constraint(equalToConstant: 360)
        buttonWidthConstraint?.isActive = true
        
        buttonHeightConstraint = button.heightAnchor.constraint(equalToConstant: 70)
        buttonHeightConstraint?.isActive = true
        
    }
    
    @objc private func didTap() {
        viewModel.switchMode()
        if viewModel.mode == .speech {
            delegate?.didTapSpeechButton(.speech)
        } else {
            delegate?.didTapSpeechButton(.notspeech)
        }
    }
    
    private func bindViewModel() {
        viewModel.modeSubject
            .subscribe(onNext: { [weak self] mode in
                self?.setupButtonAndLabel(mode)
            })
            .disposed(by: disposeBag)
    }
    
    func setupButtonAndLabel(_ mode: SpeechMode) {
        
        var configuration = UIButton.Configuration.filled()
        configuration.imagePadding = 4
        
        switch mode {
        case .speech:
            configuration.cornerStyle = .small
            if let originalImage = UIImage(named: "mic") {
                configuration.image = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale, orientation: .down)
            }
            configuration.baseBackgroundColor = .white
            
            buttonWidthConstraint?.constant = 57
            buttonHeightConstraint?.constant = 87
            notificationLabel.isHidden = true
            notificationImage.isHidden = false
            self.customShadow(color: .black, width: 0, height: 0, opacity: 0.0, radius: 0.0)
            
        case .notspeech:
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
            configuration.cornerStyle = .capsule
            configuration.image = UIImage(systemName: "mic.fill", withConfiguration: imageConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
            configuration.baseBackgroundColor = .black
            
            buttonWidthConstraint?.constant = 360
            buttonHeightConstraint?.constant = 70
            notificationLabel.isHidden = false
            notificationImage.isHidden = true
            self.customShadow(color: .black, width: 0, height: 0, opacity: 0.4, radius: 4.0)
        }
        
        button.configuration = configuration
        button.clipsToBounds = true
    }
}

protocol SpeechButtonViewDelegate: AnyObject {
    func didTapSpeechButton(_ mode: SpeechMode)
}
