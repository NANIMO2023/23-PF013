//
//  SoundManager.swift
//  Nanimo
//
//  Created by Lena on 2023/08/07.
//

import AVFoundation
import SoundAnalysis

import RxSwift

class SoundManager {
    
    var audioEngine = AVAudioEngine()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    
    var resultsObserver = ResultsObserver.shared
    let analysisQueue = DispatchQueue(label: "com.example.apple-samplecode.classifying-sounds.AnalysisQueue")
    
    init() {
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        
        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        analyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            try analyzer.add(request, withObserver: resultsObserver)
            print("Analyzer setup complete")
        } catch {
            print(String(describing: error))
        }
    }
    
    public func startAudioEngine() {
        
        do {
            try audioEngine.start()
            print("Audio engine started")
        } catch {
            print("Error in starting the Audio Engine")
        }
    }
    
    public func analyzeAudioAndGetAmplitude() -> Observable<CGFloat> {
        return Observable.create { observer in
            self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 128, format: self.inputFormat) { buffer, time in
                self.analysisQueue.async {
                    self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
                }
                
                let floatBuffer = buffer.floatChannelData![0]
                let frameCount = Int(buffer.frameLength)
                
                var sum: Float = 0.0
                for i in 0..<frameCount {
                    sum += abs(floatBuffer[i])
                }
                let averageAmplitude = sum / Float(frameCount)
                let output = 50 - abs(CGFloat(20 * log10(averageAmplitude)))
                print("Average Amplitude: \(output)")
                
                observer.onNext(output)
            }
            
            return Disposables.create {
                self.audioEngine.inputNode.removeTap(onBus: 0)
            }
        }
    }
    
    // TODO: 오디오엔진을 정지시킬 적정 타이밍 논의 필요
    public func stopAudioEngine() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.reset()
        audioEngine.stop()
        analyzer.removeAllRequests()
    }
}

