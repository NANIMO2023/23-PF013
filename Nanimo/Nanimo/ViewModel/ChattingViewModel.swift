//
//  ChattingViewModel.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/11.
//

import Foundation
import RxSwift

class ChattingViewModel {
    let myMessages = BehaviorSubject<[String]>(value: [])
    let incomingMessages = BehaviorSubject<[String]>(value: [])
    let cellHeightSubject = PublishSubject<CGFloat>()
    
    // 새 메시지를 추가하는 메서드
    func addMessageReverseTable(_ message: String) {
        var currentMessages = try! myMessages.value()
        currentMessages.append(message)
        myMessages.onNext(currentMessages)
    }
    
    // 새 메시지를 추가하는 메서드
    func addIncomingMessageTable(_ message: String) {
        var currentMessages = try! incomingMessages.value()
        currentMessages.append(message)
        incomingMessages.onNext(currentMessages)
    }
    
    /// 선택한 문장을 업데이트하는 메서드를 수정
    func updateHeight(_ height: CGFloat) {
        cellHeightSubject.onNext(height)
    }
}
