//
//  ChattingViewModel.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/11.
//

import Foundation
import RxSwift
import RxRelay

class ChattingViewModel {
    let myMessages = BehaviorSubject<[String]>(value: [])
    let incomingMessages = BehaviorSubject<[RecognitionResult]>(value: [])
    let cellHeightSubject = PublishSubject<CGFloat>()
    let isInputCompletedRelay = BehaviorRelay(value: false)
    
    var currentEditingIndex: Int?
    
    var disposeBag = DisposeBag()
    
    /// ReverseTableView 에 메세지를 추가하는 메서드
    func addMessageReverseTable(_ message: String) {
        var currentMessages = try! myMessages.value()
        currentMessages.append(message)
        myMessages.onNext(currentMessages)
    }

    /// TableView 에 새로운 메시지를 추가하는 메서드
    func updateCurrentCellWithMessage(_ message: String) {
        print("isInputCompletedRelay : ", isInputCompletedRelay.value)
        disposeBag = DisposeBag()
        
        var currentMessages = try! incomingMessages.value()
        
        if let index = currentEditingIndex, currentMessages.count == index + 1 {
            currentMessages[index].text = message
            incomingMessages.onNext(currentMessages)
        } else {
            let result = RecognitionResult(text: message, isFinal: false)
            currentMessages.append(result)
            currentEditingIndex = currentMessages.count - 1
            incomingMessages.onNext(currentMessages)
        }
        
        isInputCompletedRelay
            .asObservable()
            .subscribe(onNext: { [weak self] isInputCompleted in
                if let index = self?.currentEditingIndex, isInputCompleted {
                    
                    print("isInputCompletedRelay 가 실행되었습니다")
                    currentMessages[index].isFinal = isInputCompleted
                    // 'isInputCompleted'가 true일 때 원하는 작업을 수행합니다.
                    // 예를 들면, incomingMessages에 새 메시지를 추가하거나 변경합니다.
                    self?.incomingMessages.onNext(currentMessages)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 선택한 문장을 업데이트하는 메서드를 수정
    func updateHeight(_ height: CGFloat) {
        cellHeightSubject.onNext(height)
    }
}
