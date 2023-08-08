//
//  SoundManager.swift
//  Nanimo
//
//  Created by Lena on 2023/08/07.
//

import AVKit
import SoundAnalysis

import RxSwift

//var soundMoodClassifier = try! MusicMoodClassification()

class SoundManager {
    
    let audioEngine = AVAudioEngine()
    let mixer = AVAudioPlayerNode()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!

    var resultsObserver = ResultsObserver.shared
    let analysisQueue = DispatchQueue(label: "com.example.apple-samplecode.classifying-sounds.AnalysisQueue")
    
    public func startAudioEngine() {

        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        analyzer = SNAudioStreamAnalyzer(format: inputFormat)
        
        audioEngine.inputNode.reset()
        audioEngine.inputNode.removeTap(onBus: 0)
        analyzer.removeAllRequests()
        
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            try analyzer.add(request, withObserver: resultsObserver)
            print("added")
        } catch {
            print(String(describing: error))
            return
        }
        
        do {
            try audioEngine.start()
            print("started")
        } catch {
            print("error in starting the Audio Engine")
        }

        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 400, format: inputFormat) { buffer, time in
            self.analysisQueue.async {
                self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
    }

    public func stopAudioEngine() {
        
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.reset()
        audioEngine.stop()
        analyzer.removeAllRequests()
    }
}
