//
//  ResultsObserver.swift
//  Nanimo
//
//  Created by Lena on 2023/08/07.
//

import Foundation
import SoundAnalysis

import RxSwift

class ResultsObserver: NSObject, SNResultsObserving {
    
    static var shared = ResultsObserver()
    private var predictionSubject = PublishSubject<(identifier: String, confidence: Double)>()
    var identifierHelper = IdentifierTranslationHelper()
    var disposeBag = DisposeBag()
    
    var classifierDelegate: SoundClassifierDelegate? {
        didSet {
            predictionSubject
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] prediction in
                    self?.classifierDelegate?.displayPredictionResult(identifier: prediction.identifier,
                                                                      confidence: prediction.confidence)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        
        guard let result = result as? SNClassificationResult else { return }
        
        let sorted = result.classifications.sorted { first, second -> Bool in
            return first.confidence > second.confidence
        }
        for classification in sorted {
            let confidence = classification.confidence * 100
            if confidence > 60 {
                predictionSubject.onNext((identifier: classification.identifier, confidence: confidence))
            }
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("request completed successfully!")
    }
    
    func observePredictions() -> Observable<(identifier: String, confidence: Double)> {
        return predictionSubject.asObservable()
    }
}

