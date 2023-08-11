//
//  LaunchPadTappedViewController.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import UIKit
import RxSwift

class LaunchPadTappedViewController: UIViewController {

    // MARK: - Properties
    
    private var viewModel = SpeechViewModel(initialMode: .speech)
    private var chattingViewModel = ChattingViewModel()
    private lazy var speechButtonTextFieldView = SpeechButtonTextFieldView(viewModel: viewModel, chattingViewModel: chattingViewModel)
    private lazy var speechNotificationView = SpeechNotificationView(viewModel: viewModel)
    private lazy var sentenceTableView = SentenceTableView(viewModel: viewModel)
    
    private lazy var chattingTableView = ChattingTableView(isReversed: false, chattingViewModel: chattingViewModel)
    private lazy var reverseChattingTableView = ChattingTableView(isReversed: true, chattingViewModel: chattingViewModel)
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        [reverseChattingTableView, chattingTableView, speechButtonTextFieldView, sentenceTableView, speechNotificationView].forEach { view.addSubview($0) }
        
        configureConstraints()
        view.backgroundColor = .white
        
        
        speechButtonTextFieldView.backgroundColor = .white
        
        reverseChattingTableView.backgroundColor = .green
        chattingTableView.backgroundColor = .blue
        
        speechNotificationView.bind()
    }
    
    // MARK: - methods for layouts
    
    private func configureConstraints() {
        
        reverseChattingTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: chattingTableView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 10, height: 341)
        
        
        chattingTableView.anchor(top: reverseChattingTableView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, height: 341)
        
        
        speechNotificationView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingLeading: 12, paddingTrailing: 117, height: 43)
        
        speechButtonTextFieldView.anchor(top: speechNotificationView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeading: 0, paddingTrailing: 0)
                                    
        
        speechButtonTextFieldView.setHeight(height: 54)
        
    }
    
    /// 키보드가 올라와 있을 때 다른 곳을 터치 시 키보드가 사라지는 역할을 하는 메서드
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// SpeechButtonTextFieldView와 SentenceTableView에 동일한 뷰모델을 설정
    private func bindViewModel() {
        speechButtonTextFieldView.viewModel = viewModel
        sentenceTableView.viewModel = viewModel
        observeTextFieldAndKeyboard()
    }
    
    /// 키보드가 올라올때 동작하는 함수
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                
                hideSubView(notification: true, sentence: false, chatting: true)
                
                sentenceTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: speechButtonTextFieldView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: keyboardSize.height)

                print(speechButtonTextFieldView.frame.height)

                speechButtonTextFieldView.anchor(top: sentenceTableView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
                
                viewModel.isKeyboardVisible.accept(true)
                view.layoutIfNeeded()
            }
        }
    }
    
    /// 키보드가 내려갈때 동작하는 함수
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
        hideSubView(notification: false, sentence: true, chatting: false)
        viewModel.isKeyboardVisible.accept(false)
    }

    /// View 를 감추거나 보여주는 역할을 하는 메서드
    func hideSubView(notification: Bool, sentence: Bool, chatting: Bool) {
        speechNotificationView.isHidden = notification
        sentenceTableView.isHidden = sentence
        chattingTableView.isHidden = chatting
        reverseChattingTableView.isHidden = chatting
    }
    
    /// 앱의 여러 상황에 맞게 분기처리를 하기 위한 함수
    func observeTextFieldAndKeyboard() {
        Observable.combineLatest(viewModel.isEmptyTextField, viewModel.isKeyboardVisible)
            .subscribe(onNext: { [weak self] (isEmpty, isKeyboardVisible) in
                
                switch (isEmpty, isKeyboardVisible) {
                case (true, true): /// 키보드가 올라가 있고 Text 가 비어있을 때
                    self?.sentenceTableView.isHidden = !isEmpty
                case (false, true): ///키보드가 올라가 있고 Text 가 있을 때
                    self?.sentenceTableView.isHidden = !isEmpty
                case (false, false): /// 키보드가 내려가 있고 Text 가 있을 때
                    self?.sentenceTableView.isHidden = !isEmpty
                case (true, false): /// 키보드가 내려가 있고 Text 가 비어있을 때
                    self?.sentenceTableView.isHidden = isEmpty
                }
            })
            .disposed(by: disposeBag)
    }
}
