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
    private lazy var lastMessageLabel = ChattingMessageView()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .emptyViewGray
        return view
    }()
    
    private var keyboardHeight: CGFloat = 0.0
    private var speechButtonTextFieldViewTopConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        speechButtonTextFieldView.backgroundColor = .white
        
        addSubviews()
        configureConstraints()
        hideKeyboardWhenTappedAround()
        
        sentenceTableView.isHidden = true
        lastMessageLabel.isHidden = true
        
        chattingViewModel.addIncomingMessageTable("주문하시겠어요?")
        bindViewModel()
        speechNotificationView.bind()
        
        speechNotificationView.fadeOut(duration: 3)
        
        chattingViewModel.incomingMessages
            .map { $0.last }         // 배열의 마지막 값을 가져옴
            .filter { $0 != nil }    // nil이 아닌 값만 필터링
            .subscribe(onNext: { [weak self] latestMessage in
                self?.lastMessageLabel.configure(name: latestMessage)
            })
            .disposed(by: disposeBag)
        
        /// 키보드가 올라가고 내려갈때 동작하는 메서드 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: - methods for layouts
    
    private func addSubviews() {
        [reverseChattingTableView, chattingTableView, speechButtonTextFieldView, sentenceTableView, speechNotificationView, lastMessageLabel, emptyView].forEach { view.addSubview($0) }
    }
    
    private func configureConstraints() {
        speechButtonTextFieldViewTopConstraint = speechButtonTextFieldView.topAnchor.constraint(equalTo: speechNotificationView.bottomAnchor, constant: 8)
        speechButtonTextFieldViewTopConstraint.isActive = true
    
        reverseChattingTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: emptyView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 10, height: 341)
        
        emptyView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, height: 5)
        
        chattingTableView.anchor(top: emptyView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: speechButtonTextFieldView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        speechNotificationView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingLeading: 12, paddingTrailing: 117, height: 43)
        
        speechButtonTextFieldView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingLeading: 0, paddingTrailing: 0)
                                    
        speechButtonTextFieldView.setHeight(height: 54)
    }
    
    /// 키보드가 올라와 있을 때 다른 곳을 터치 시 키보드가 사라지는 역할을 하는 메서드
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
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
                self.keyboardHeight = keyboardSize.height
                hideSubView(notification: true, sentence_Label: false, empty_Chatting: true)
                
                
                speechButtonTextFieldViewTopConstraint.isActive = false
                speechButtonTextFieldViewTopConstraint = speechButtonTextFieldView.topAnchor.constraint(equalTo: sentenceTableView.bottomAnchor, constant: 0)
                speechButtonTextFieldViewTopConstraint.isActive = true

                sentenceTableView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: speechButtonTextFieldView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: keyboardSize.height)

                speechButtonTextFieldView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)

                lastMessageLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: sentenceTableView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: keyboardSize.height, paddingBottom: 10)

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
        
        hideSubView(notification: false, sentence_Label: true, empty_Chatting: false)
        viewModel.isKeyboardVisible.accept(false)
        
        speechButtonTextFieldViewTopConstraint.isActive = false
        speechButtonTextFieldViewTopConstraint = speechButtonTextFieldView.topAnchor.constraint(equalTo: speechNotificationView.bottomAnchor, constant: 8)
        speechButtonTextFieldViewTopConstraint.isActive = true
        
        view.layoutIfNeeded()
    }
    
    /// View 를 감추거나 보여주는 역할을 하는 메서드
    func hideSubView(notification: Bool, sentence_Label: Bool, empty_Chatting: Bool) {
        speechNotificationView.isHidden = notification
        sentenceTableView.isHidden = sentence_Label
        lastMessageLabel.isHidden = sentence_Label
        emptyView.isHidden = empty_Chatting
        chattingTableView.isHidden = empty_Chatting
        reverseChattingTableView.isHidden = empty_Chatting
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

extension LaunchPadTappedViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view as? UITableViewCell {
            return false
        } else if let touchedSuperview = touch.view?.superview as? UITableViewCell {
            return false
        }
        return true
    }
}
