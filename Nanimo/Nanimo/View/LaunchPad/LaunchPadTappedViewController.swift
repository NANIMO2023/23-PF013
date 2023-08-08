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
    private lazy var speechButtonTextFieldView = SpeechButtonTextFieldView(viewModel: viewModel)
    private lazy var speechNotificationView = SpeechNotificationView(viewModel: viewModel)
    private lazy var sentenceTableView = SentenceTableView(viewModel: viewModel)
    
    private lazy var chattingTableView = ChattingTableView(isReversed: false)
    private lazy var reverseChattingTableView = ChattingTableView(isReversed: true)
    
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
        
        hideKeyboardWhenTappedAround()
        
    }
    
    // MARK: - methods for layouts
    
    private func configureConstraints() {
        
        reverseChattingTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: chattingTableView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 10, height: 341)
        
        
        chattingTableView.anchor(top: reverseChattingTableView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, height: 341)
        
        
        speechNotificationView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingLeading: 12, paddingTrailing: 117, height: 43)
        
        speechButtonTextFieldView.anchor(top: speechNotificationView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingLeading: 0, paddingTrailing: 0)
                                    
        
        speechButtonTextFieldView.setHeight(height: 54)
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// SpeechButtonTextFieldView와 SentenceTableView에 동일한 뷰모델을 설정
    private func bindViewModel() {
        
        print("실행")
        speechButtonTextFieldView.viewModel = viewModel
        sentenceTableView.viewModel = viewModel
//        showSentenceTableView()
//        viewModel.shouldShowTableView
//            .subscribe(onNext: { [weak self] shouldShow in
//                print("TableView Hidden: \(!shouldShow)")
//                self?.sentenceTableView.isHidden = !shouldShow
//            })
//            .disposed(by: disposeBag)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                
                viewModel.updateKeyboardVisibility(isVisible: true)
                
                speechNotificationView.isHidden = true
                
//                viewModel.shouldShowTableView.onNext(false)
                showSentenceTableView()
                
                speechButtonTextFieldView.anchor(height: 44)
                
                sentenceTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: speechButtonTextFieldView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: keyboardSize.height, paddingLeading: 12, paddingTrailing: 12)

                print(speechButtonTextFieldView.frame.height)

                speechButtonTextFieldView.anchor(top: sentenceTableView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingLeading: 5, paddingTrailing: 5)
                
//                sentenceTableView.isHidden = false
                view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
        speechNotificationView.isHidden = false
//        sentenceTableView.isHidden = true
//        viewModel.shouldShowTableView.onNext(true)
//        showSentenceTableView()
        viewModel.updateKeyboardVisibility(isVisible: false)
        
        
//        sentenceTableViewBottomConstraint = sentenceTableView.bottomAnchor.constraint(equalTo: speechButtonTextFieldView.topAnchor)
//        sentenceTableViewBottomConstraint?.isActive = true
    }

    func showSentenceTableView() {
        viewModel.shouldShowTableView
            .subscribe(onNext: { [weak self] shouldShow in
                print("Keyboard TableView Hidden: \(!shouldShow)")
                self?.sentenceTableView.isHidden = shouldShow
            })
            .disposed(by: disposeBag)
    }
    
    func isEmptyTextField() {
        viewModel.isEmptyTextField
            .subscribe(onNext: { [weak self] isEmpty in
                print("Empty TableView Hidden: \(!isEmpty)")
                self?.sentenceTableView.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
    }
    
}
