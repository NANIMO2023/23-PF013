//
//  SpeechRecognitionManager.swift
//  Nanimo
//
//  Created by ParkJunHyuk on 2023/08/18.
//

import Foundation
import AVFoundation
import Speech
import RxSwift
import RxCocoa
import Accelerate

struct RecognitionResult {
    var text: String
    var isFinal: Bool
}

class SpeechRecognitionManager: NSObject, SFSpeechRecognizerDelegate {

    // MARK: - Properties

    // 싱글톤 인스턴스 생성
    static let shared = SpeechRecognitionManager()

    private var speechRecognizer: SFSpeechRecognizer
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    var isRecording: Bool {
        return audioEngine.isRunning
    }
    
    private var tempMessage: String? = nil
    private var isVoiceDetected: Bool = false
    
    private var isFinal = false {
        didSet {
            if oldValue != isFinal {
                isFinalSubject.onNext(isFinal)
                print("isFinal 값 전달: ", isFinal)
            }
        }
    }
    
    // MARK: - Rx Properties

    private var recognitionSubject = PublishSubject<RecognitionResult>()
    let isFinalSubject = PublishSubject<Bool>() // BehaviorSubject<Bool>(value: false)
    var recognition: Observable<RecognitionResult> {
        return recognitionSubject.asObservable()
    }

    private var disposeBag = DisposeBag()

    // MARK: - Life Cycles

    private override init() {
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
        super.init()
        self.speechRecognizer.delegate = self

    }

    // MARK: - method

    func requestAuthorization() -> Observable<Bool> {
        return Observable.create { observer in
            SFSpeechRecognizer.requestAuthorization { authStatus in
                OperationQueue.main.addOperation {
                    switch authStatus {
                        case .authorized:
                            // 권한이 허용됨
                            observer.onNext(true)
                            observer.onCompleted()
                        case .denied, .restricted, .notDetermined:
                            // 권한이 거부됨 or 제한됨 or 아직 결정되지 않음
                            observer.onNext(false)
                            observer.onCompleted()
                        default:
                            observer.onNext(false)
                            observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }

    func startRecording() -> Observable<Error?> {
        recognitionSubject = PublishSubject<RecognitionResult>()
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onNext(NSError(domain: "com.example.speechrecognition", code: 2, userInfo: [NSLocalizedDescriptionKey: "Manager deallocated"]))
                observer.onCompleted()
                return Disposables.create()
            }

            if self.isRecording {
                observer.onNext(NSError(domain: "com.example.speechrecognition", code: 1, userInfo: [NSLocalizedDescriptionKey: "Already recording"]))
                observer.onCompleted()
                return Disposables.create()
            }

            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

                self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

                guard let recognitionRequest = self.recognitionRequest else {
                    observer.onNext(NSError(domain: "com.example.speechrecognition", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unable to create request"]))
                    observer.onCompleted()
                    return Disposables.create()
                }

                let inputNode = self.audioEngine.inputNode
                self.recognitionTask = self.speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                    if let result = result {
                        print("현재 상태: ", result.isFinal)
                        self.isFinal = result.isFinal
                        
                        let recognitionResult = RecognitionResult(text: result.bestTranscription.formattedString, isFinal: result.isFinal)

                        self.recognitionSubject.onNext(recognitionResult)
                        print(result.bestTranscription.formattedString)
                        
//                        self.latestTranscription = result.bestTranscription.formattedString
                    } else if let error = error {
                        observer.onNext(error)
                        observer.onCompleted()
                    }
                }

                let recordingFormat = inputNode.outputFormat(forBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                    recognitionRequest.append(buffer)
                }

                self.audioEngine.prepare()
                try self.audioEngine.start()

            } catch {
                observer.onNext(error)
                observer.onCompleted()
            }

            return Disposables.create {
                self.stopRecording()
            }
        }
    }
    
    func calculateLevel(buffer: AVAudioPCMBuffer) -> Float {
        guard let floatData = buffer.floatChannelData else { return -100.0 }  // -100 dB를 기본 최소 값으로 설정합니다.

        let channelCount = Int(buffer.format.channelCount)
        let length = vDSP_Length(buffer.frameLength)

        var squaredSum: Float = 0.0

        for channel in 0..<channelCount {
            var squared: [Float] = Array(repeating: 0.0, count: Int(buffer.frameLength))
            vDSP_vsq(floatData[channel], 1, &squared, 1, length)
            let channelSquaredSum: Float = squared.reduce(0, +)
            squaredSum += channelSquaredSum
        }

        let meanSquared = squaredSum / Float(buffer.frameLength * buffer.format.channelCount)
        let rms = sqrt(meanSquared)

        // RMS 값을 dB로 변환
        let levelInDB = 20 * log10(rms)
        return levelInDB
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        isFinalSubject
            .filter { $0 == true }
//            .take(1) // 처음으로 ture 가 나오면 그 이후의 이벤트는 무시
            .subscribe(onNext: { [weak self] _ in
                self?.audioEngine.inputNode.removeTap(onBus: 0)
                self?.recognitionTask?.cancel()
                self?.recognitionTask = nil
                self?.recognitionRequest = nil
                self?.recognitionSubject.onCompleted()
            })
            .disposed(by: disposeBag)
    }
}
