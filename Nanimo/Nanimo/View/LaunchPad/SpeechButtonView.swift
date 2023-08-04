//
//  SpeechButtonView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit
import RxSwift

class SpeechButtonView: UIButton {
    
    let viewModel: SpeechViewModel
    private let disposeBag = DisposeBag()

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
    
    init(viewModel: SpeechViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        bindViewModel()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.modeSubject
            .subscribe(onNext: { [weak self] mode in
                self?.setupSocialButton(mode)
            })
            .disposed(by: disposeBag)
    }

    @objc private func didTap() {
        viewModel.switchMode()
    }
}

extension SpeechButtonView {
    func setupSocialButton(_ mode: SpeechViewModel.SpeechMode) {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.imagePadding = 4
        
        switch mode {
        case .speech:
            configuration.image = UIImage(systemName: "speaker.wave.3.fill", withConfiguration: imageConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
            
            configuration.baseBackgroundColor = .bulletGray
            
        case .notspeech:
            configuration.image = UIImage(systemName: "speaker.slash.fill", withConfiguration: imageConfig)?.withTintColor(.bulletGray, renderingMode: .alwaysOriginal)
            
            configuration.baseBackgroundColor = .detailBackgroundGrayButton
        }

        self.configuration = configuration
        self.clipsToBounds = true
    }
}
