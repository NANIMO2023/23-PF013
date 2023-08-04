//
//  SpeechButtonTextFieldView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit
import RxSwift

class SpeechButtonTextFieldView: UIView{
    
    // MARK: - Properties
    
    var viewModel: SpeechViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    var speechButton: SpeechButtonView

    private let disposeBag = DisposeBag()
    
    lazy var textFieldView: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "입력해서 말하기"
        textfield.textColor = .bulletGray
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    lazy var textFieldBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.24)
        view.layer.cornerRadius = 20
        return view
    }()
    
    // MARK: - Life Cycles
    
    init(viewModel: SpeechViewModel) {
        self.viewModel = viewModel
        self.speechButton = SpeechButtonView(viewModel: viewModel)
        
        super.init(frame: .zero)
        
        configureTextField()
        bindViewModel()
        bindTextField()
        
        // SpeechViewModel의 isKeyboardVisible을 구독하여 배경색 변경
        viewModel.isKeyboardVisible
            .subscribe(onNext: { [weak self] isVisible in
                self?.textFieldBackground.backgroundColor = isVisible ? .white : UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.24)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods for layouts
    
    func configureTextField() {
        self.addSubview(textFieldBackground)
        
        textFieldBackground.addSubview(textFieldView)
        textFieldBackground.addSubview(speechButton)
        
//        if let speechButton = speechButton {
//            textFieldBackground.addSubview(speechButton)
//        }
        
        textFieldBackground.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing:self.trailingAnchor, paddingTop: 10)
        
        textFieldView.anchor(top: textFieldBackground.topAnchor, leading: speechButton.trailingAnchor, bottom: textFieldBackground.bottomAnchor,trailing: textFieldBackground.trailingAnchor, paddingTop: 10, paddingLeading: 12, paddingBottom: 10, paddingTrailing: 12, height: 24)
        
        speechButton.anchor(top: textFieldBackground.topAnchor, leading: textFieldBackground.leadingAnchor, bottom: textFieldBackground.bottomAnchor,trailing: textFieldView.leadingAnchor, paddingTop: 6, paddingLeading: 8, paddingBottom: 6, paddingTrailing: 12, width: 38, height: 32)
    }
}

//extension SpeechButtonTextFieldView: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//
//        viewModel?.updateSelectedSentence(updatedText)
//
//        return true
//    }
//}

extension SpeechButtonTextFieldView {
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        // viewModel.selectedSentence를 구독하여 선택한 문장을 textField에 설정
        viewModel.selectedSentence
            .subscribe(onNext: { [weak self] sentence in
                print("문장 넣기")
                self?.textFieldView.text = sentence
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTextField() {
        textFieldView.rx.text.orEmpty
            .map { $0.isEmpty }
            .bind(to: viewModel?.isEmptyTextField ?? BehaviorSubject<Bool>(value: true))
            .disposed(by: disposeBag)
    }
}
