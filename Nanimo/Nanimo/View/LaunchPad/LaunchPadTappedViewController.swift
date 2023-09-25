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
    
    private var viewModel = SpeechViewModel(initialMode: .notspeech)
    private var chattingViewModel = ChattingViewModel()
    
    private lazy var speechTextFieldView = SpeechTextFieldView(viewModel: viewModel, chattingViewModel: chattingViewModel)
    private lazy var sentenceTableView = SentenceTableView(viewModel: viewModel)
    private lazy var chattingTableView = ChattingTableView(isReversed: false, chattingViewModel: chattingViewModel)
    private lazy var reverseChattingTableView = ChattingTableView(isReversed: true, chattingViewModel: chattingViewModel)
    private lazy var speechButtonView = SpeechButtonView(viewModel: viewModel)
    private lazy var lastMessageView = LastMessageView()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .chattingCellBackgroundGray
        return view
    }()
    
    private lazy var placeHolderView = PlaceHolderView()
    
    private var keyboardHeight: CGFloat = 0.0
    private var speechButtonTextFieldViewTopConstraint: NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        speechTextFieldView.backgroundColor = .white
        
        addSubviews()
        configureConstraints()
        hideKeyboardWhenTappedAround()
        
        sentenceTableView.isHidden = true
        lastMessageView.isHidden = true
        
        speechButtonView.delegate = self
        
        bindViewModel()
        
        chattingViewModel.incomingMessages
            .map { $0.last }         // 배열의 마지막 값을 가져옴
            .filter { $0 != nil }    // nil이 아닌 값만 필터링
            .subscribe(onNext: { [weak self] messageResult in
                self?.lastMessageView.configure(name: messageResult?.text)
            })
            .disposed(by: disposeBag)
        
        /// 키보드가 올라가고 내려갈때 동작하는 메서드 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        SpeechRecognitionManager.shared.isFinalSubject
            .subscribe(onNext: { [weak self] result in
                self?.chattingViewModel.isInputCompletedRelay.accept(result)
                print("isInputCompletedRelay 에 전달: ", result)
            })
            .disposed(by: disposeBag)
        
        chattingViewModel.myMessages
            .subscribe(onNext: { [weak self] result in
                if result.count > 0 {
                    self?.placeHolderView.isHidden = true
                } else {
                    self?.placeHolderView.isHidden = false
                }
                
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SpeechRecognitionManager.shared.requestAuthorization()
            .subscribe(onNext: { [weak self] authorized in
                if authorized {
                    print("STT 권한 인증")
                    self?.startRecognition()
                } else {
                    // 권한 거부에 대한 처리
                    print("Speech recognition authorization denied")
                }
            })
            .disposed(by: disposeBag)

    }
    
    // MARK: - methods for layouts
    
    private func startRecognition() {
        // 음성 인식 시작
        SpeechRecognitionManager.shared.startRecording()
            .subscribe(
                onNext: { [weak self] error in
                    // 에러 처리 (옵셔널)
                    if let error = error {
                        print("Recording error: \(error)")
                    }
                },
                onDisposed: {
                    print("Recording completed or stopped")
                }
            )
            .disposed(by: disposeBag)

        // 인식된 텍스트 받아오기
        SpeechRecognitionManager.shared.recognition
            .subscribe(onNext: { [weak self] recognitionResult in
                self?.chattingViewModel.updateCurrentCellWithMessage(recognitionResult.text)
                print("Recognized text: \(recognitionResult.text)")
                // TODO: 화면에 텍스트 표시 또는 기타 처리
            })
            .disposed(by: disposeBag)
    }
    
    private func addSubviews() {
        [reverseChattingTableView, chattingTableView, speechTextFieldView, sentenceTableView, emptyView, speechButtonView, lastMessageView, placeHolderView].forEach { view.addSubview($0) }
    }
    
    private func configureConstraints() {
        reverseChattingTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: emptyView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 10, height: 341)
        
        emptyView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, height: 5)
        
        chattingTableView.anchor(top: emptyView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: speechTextFieldView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        speechTextFieldView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingLeading: 13, paddingTrailing: 13)
                                    
        speechTextFieldView.setHeight(height: 54)
        
        speechButtonView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 17, paddingLeading: 15, paddingTrailing: 15)
        speechButtonView.transform = CGAffineTransform(scaleX: -1, y: -1)
        
        placeHolderView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: emptyView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 183, paddingLeading: 66, paddingBottom: 23, paddingTrailing: 21)
        placeHolderView.transform = CGAffineTransform(scaleX: -1, y: -1)
        
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
        speechTextFieldView.viewModel = viewModel
        sentenceTableView.viewModel = viewModel
        observeTextFieldAndKeyboard()
    }
    
    /// 키보드가 올라올때 동작하는 함수
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                self.keyboardHeight = keyboardSize.height
                hideSubView(notification: true, sentenceLabel: false, emptyChatting: true)

                sentenceTableView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: speechTextFieldView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: keyboardSize.height)

                speechTextFieldView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)

                lastMessageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: sentenceTableView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: keyboardSize.height, paddingBottom: 10)

                viewModel.isKeyboardVisible.accept(true)
                
                placeHolderView.isHidden = true
                view.layoutIfNeeded()
            }
        }
    }
    
    /// 키보드가 내려갈때 동작하는 함수
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
        hideSubView(notification: false, sentenceLabel: true, emptyChatting: false)
        viewModel.isKeyboardVisible.accept(false)

        view.layoutIfNeeded()
    }
    
    /// View 를 감추거나 보여주는 역할을 하는 메서드
    func hideSubView(notification: Bool, sentenceLabel: Bool, emptyChatting: Bool) {
        sentenceTableView.isHidden = sentenceLabel
        lastMessageView.isHidden = sentenceLabel
//        placeHolderView.isHidden = emptyChatting
        emptyView.isHidden = emptyChatting
        chattingTableView.isHidden = emptyChatting
        reverseChattingTableView.isHidden = emptyChatting
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

extension LaunchPadTappedViewController: SpeechButtonViewDelegate {
    func didTapSpeechButton(_ mode: SpeechMode) {
        print("현재 모드 : \(mode)")
        switch mode {
        case .speech:
//            placeHolderView.addBlurEffect(style: .dark)
            self.startRecognition()
            guard let index = chattingViewModel.currentEditingIndex else { return }
            chattingViewModel.currentEditingIndex = index + 1
        case .notspeech:
//            placeHolderView.removeBlurEffect()
            
            SpeechRecognitionManager.shared.stopRecording()
        }
    }
}
