//
//  SpeechButtonTextFieldView.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit
import RxSwift

class SpeechTextFieldView: UIView{
    
    // MARK: - Properties
    
    var viewModel: SpeechViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    var chattingViewModel: ChattingViewModel? {
        didSet {
            bindChattingViewModel()
        }
    }

    private let disposeBag = DisposeBag()
    
    lazy var textFieldView: UITextField = {
        let textfield = UITextField()
        textfield.textColor = .bulletGray
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    lazy var textFieldBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.24)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.detailBackgroundGrayButton.cgColor
        return view
    }()
    
    // MARK: - Life Cycles
    
    init(viewModel: SpeechViewModel, chattingViewModel: ChattingViewModel) {
        self.viewModel = viewModel
        self.chattingViewModel = chattingViewModel
        
        super.init(frame: .zero)
        
        configureTextField()
        bindViewModel()
        bindTextField()
        bindChattingViewModel()
        
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

        textFieldBackground.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing:self.trailingAnchor, paddingTop: 10, paddingLeading: 5, paddingTrailing: 5)
        
        textFieldView.anchor(top: textFieldBackground.topAnchor, leading: textFieldBackground.leadingAnchor, bottom: textFieldBackground.bottomAnchor,trailing: textFieldBackground.trailingAnchor, paddingTop: 10, paddingLeading: 12, paddingBottom: 10, paddingTrailing: 12, height: 24)
    }
}

extension SpeechTextFieldView {
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
            .map { $0.isEmpty } // 비어있을 때 true 를 반환
            .bind(to: viewModel?.isEmptyTextField ?? BehaviorSubject<Bool>(value: false))
            .disposed(by: disposeBag)
    }
    
    /// 키보드의 엔터를 누를시 동작하는 내용
    private func bindChattingViewModel() {
       guard let chattingViewModel = chattingViewModel else {
           return
       }

       textFieldView.rx.controlEvent(.editingDidEndOnExit)
           .withLatestFrom(textFieldView.rx.text.orEmpty)
           .filter { !$0.isEmpty }
           .subscribe(onNext: { [weak self] text in
               chattingViewModel.addMessageReverseTable(text)
               self?.textFieldView.text = ""
           })
           .disposed(by: disposeBag)
   }
}



