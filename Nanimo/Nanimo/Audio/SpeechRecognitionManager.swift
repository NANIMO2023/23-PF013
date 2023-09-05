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
    
    private var previousTranscription: String = ""
    private var isVoiceDetected: Bool = false
    
    // MARK: - Rx Properties

    private var recognitionSubject = PublishSubject<String>()

    var recognition: Observable<String> {
        return recognitionSubject.asObservable()
    }

    private let disposeBag = DisposeBag()

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
        recognitionSubject = PublishSubject<String>()
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
                        self.recognitionSubject.onNext(result.bestTranscription.formattedString)
                        print(result.bestTranscription.formattedString)
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
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        recognitionSubject.onCompleted()
    }
}
