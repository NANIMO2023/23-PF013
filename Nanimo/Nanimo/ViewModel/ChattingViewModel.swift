//
//  ChattingViewModel.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/11.
//

import RxSwift

class ChattingViewModel {
    let messages = BehaviorSubject<[String]>(value: [])

    // 새 메시지를 추가하는 메서드
    func addMessage(_ message: String) {
        var currentMessages = try! messages.value()
        currentMessages.append(message)
        messages.onNext(currentMessages)
    }
}
