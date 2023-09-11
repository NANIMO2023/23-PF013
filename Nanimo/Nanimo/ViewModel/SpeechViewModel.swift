//
//  SpeechViewModel.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/05.
//

import RxSwift
import RxRelay

enum SpeechMode {
    case speech
    case notspeech
}

class SpeechViewModel {
    
    // MARK: - Properties
    
    var mode: SpeechMode = .notspeech
    
    let modeSubject: BehaviorSubject<SpeechMode>
    let sentences: BehaviorSubject<[SentenceModel]>
    let recentSentences: Observable<[SentenceModel]>
    let favoriteSentences: Observable<[SentenceModel]>
    
    /// 선택한 문장을 담는 BehaviorSubject를 추가
    private let selectedSentenceSubject = BehaviorSubject<String?>(value: nil)
    
    var selectedSentence: Observable<String?> {
        return selectedSentenceSubject.asObservable()
    }
    
    /// 선택한 문장을 업데이트하는 메서드를 수정
    func updateSelectedSentence(_ sentence: String?) {
        selectedSentenceSubject.onNext(sentence)
    }
    
    /// SentencesTableView 를 보여주거나 숨기는 BehaviorSubject
    let isEmptyTextField = BehaviorSubject<Bool>(value: false)

    /// 키보드의 상태를 나타내는 BehaviorSubject
    let isKeyboardVisible = BehaviorRelay<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    
    init(initialMode: SpeechMode) {
        modeSubject = BehaviorSubject(value: initialMode)
        
        sentences = BehaviorSubject(value: [
            SentenceModel(isBookmark: false, sentence: "강아지 만져봐도 되나요"),
            SentenceModel(isBookmark: false, sentence: "이 음료에 카페인이 들어있나요"),
            SentenceModel(isBookmark: true, sentence: "지나갈게요 비켜주세요"),
            SentenceModel(isBookmark: true, sentence: "주문할게요"),
            SentenceModel(isBookmark: true, sentence: "그냥 말씀하시면 앱을 통해서 들을게요"),
            SentenceModel(isBookmark: true, sentence: "안녕하세요")
        ])
        
        recentSentences = sentences.asObservable()
            .map { $0.filter { !$0.isBookmark } }
            .share(replay: 1, scope: .forever)
        favoriteSentences = sentences.asObservable()
            .map { $0.filter { $0.isBookmark } }
            .share(replay: 1, scope: .forever)
    }
    
    func switchMode() {
        let newMode: SpeechMode
        if let currentMode = try? modeSubject.value(), currentMode == .speech {
            newMode = .notspeech
            mode = .notspeech
        } else {
            newMode = .speech
            mode = .speech
        }
        
        modeSubject.onNext(newMode)
    }
    
    func updateSentences(newSentences: [SentenceModel]) {
        sentences.onNext(newSentences)
    }
}
