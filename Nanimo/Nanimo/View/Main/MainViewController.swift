//
//  MainViewController.swift
//  Nanimo
//
//  Created by Lena on 2023/07/12.
//

import SwiftUI
import AVFoundation
import SoundAnalysis

import RxSwift
import RxCocoa
import Lottie

protocol SoundClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double)
}

class MainViewController: UIViewController, SoundClassifierDelegate {
    
    // MARK: - Properties
    
    private var resultsObserver = ResultsObserver.shared
    private var previousPrediction = ""
    private var isHearing = false
    private var identifierTranslationHelper = IdentifierTranslationHelper()
    private var disposeBag = DisposeBag()
    
    var soundManager = SoundManager()
    
    private let minuteLabel = UILabel()
    private let soundNotificationLabel = UILabel()
    private let todayAudioLabel = UILabel()
    
    let soundVisualizerView: LottieAnimationView = .init(name: "animation")
    
    private let backgroundGradientBlockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: gradientGreenBlockImage)
        return imageView
    }()
    
    let dailyAudioChartHostingView = UIHostingController(rootView: AudioPointMarkView())
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("자세히", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.backgroundColor = .detailBackgroundGrayButton
        button.setTitleColor(.detailTextGrayButton, for: .normal)
        button.setWidth(width: 50)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var audioStackView: UIStackView = {
        var bulletView1 = BulletView()
        var bulletView2 = BulletView()
        var bulletView3 = BulletView()
        var bulletView4 = BulletView()
        
        let stackView = UIStackView(arrangedSubviews: [bulletView1, bulletView2, bulletView3, bulletView4])
        
        // TODO: 오디오 데이터 들어오면 소리 종류 중 가장 많은 소리가 난 상위 4개를 띄우도록 구현 예정
        bulletView1.setLabels(soundName: "자동차 지나가는 소리", soundNumber: 8)
        bulletView2.setLabels(soundName: "물건 떨어지는 소리", soundNumber: 6)
        bulletView3.setLabels(soundName: "개 짖는 소리", soundNumber: 2)
        bulletView4.setLabels(soundName: "아기 울음 소리", soundNumber: 1)
        
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        resultsObserver.classifierDelegate = self
        
        makeHostingViewToUIView()
        [minuteLabel,soundVisualizerView, soundNotificationLabel].forEach { backgroundGradientBlockImage.addSubview($0) }
        [backgroundGradientBlockImage, todayAudioLabel, detailButton, audioStackView].forEach { view.addSubview($0) }
        setLabel()
        configureLayout()
        soundManager.startAudioEngine()
        
        // 소리 분석 및 현재 오디오의 레벨에 따라 visualizer 제어하는 로직
        soundManager.analyzeAudioAndGetAmplitude()
            .map { amplitude in
                return amplitude > 9.5
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isHearing in
                if isHearing {
                    self?.soundVisualizerView.play()
                } else {
                    self?.soundVisualizerView.pause()
                    self?.soundNotificationLabel.text = "주변이 조용해요"
                }
            })
            .disposed(by: disposeBag)
        
        // 소리분석 결과를 구독해 label 업데이트
        resultsObserver.observePredictions()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] prediction in
                if let thisIdentifier = self?.resultsObserver.identifierHelper.identifier[prediction.identifier], thisIdentifier != self?.previousPrediction {
                    self?.soundNotificationLabel.fadeOut()
                    self?.soundNotificationLabel.text = "\(thisIdentifier) 소리가 나고 있어요"
                    self?.soundNotificationLabel.fadeIn()
                    self?.soundNotificationLabel.adjustsFontSizeToFitWidth = true
                    self?.previousPrediction = thisIdentifier
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - methods for layouts
    
    private func setLabel() {
        backgroundGradientBlockImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        minuteLabel.setLabel(labelText: " 지금은 ", backgroundColor: .black, weight: .medium, textSize: 16, labelColor: .white)
        
        soundNotificationLabel.setLabel(labelText: "주변이 조용해요", backgroundColor: .clear, weight: .bold, textSize: 24, labelColor: .black)
        
        todayAudioLabel.setLabel(labelText: "오늘 발생한 소리", backgroundColor: .clear, weight: .bold, textSize: 22, labelColor: .black)
    }
    
    private func makeHostingViewToUIView() {
        addChild(dailyAudioChartHostingView)
        dailyAudioChartHostingView.view.frame = .zero
        view.addSubview(dailyAudioChartHostingView.view)
        dailyAudioChartHostingView.didMove(toParent: self)
    }
    
    private func configureLayout() {
        minuteLabel.anchor(top: backgroundGradientBlockImage.topAnchor, leading: backgroundGradientBlockImage.leadingAnchor, paddingTop: 85, paddingLeading: 21)
        minuteLabel.setHeight(height: 24)
        
        soundVisualizerView.setHeight(height: 28)
        soundVisualizerView.setWidth(width: 32)
        soundVisualizerView.anchor(top: minuteLabel.bottomAnchor, leading: backgroundGradientBlockImage.leadingAnchor, paddingTop: 8, paddingLeading: 21)
        soundNotificationLabel.anchor(top: minuteLabel.bottomAnchor, leading: soundVisualizerView.trailingAnchor, paddingTop: 8, paddingLeading: 8)
        
        dailyAudioChartHostingView.view.centerX(inView: view)
        dailyAudioChartHostingView.view.setWidth(width: view.bounds.width * 0.98)
        dailyAudioChartHostingView.view.anchor(top: soundNotificationLabel.bottomAnchor, paddingTop: 27)
        
        todayAudioLabel.anchor(top: dailyAudioChartHostingView.view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 25, paddingLeading: 19)
        
        detailButton.anchor(top: dailyAudioChartHostingView.view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 25, paddingTrailing: 19)
        
        audioStackView.anchor(top: todayAudioLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 5, paddingLeading: 18)
    }
}

// MARK: - Set Prediction

extension MainViewController {
    func displayPredictionResult(identifier: String, confidence: Double) {
        let percentConfidence = String(format: "%.2f", confidence)
        let myIdentifier = identifierTranslationHelper.identifier[identifier]
        print("identifier: \(String(describing: myIdentifier)), percentConfidence: \(percentConfidence)")
    }
}

// MARK: - Animation Configuration

extension MainViewController {
    func configureAnimation() {
        soundVisualizerView.loopMode = .loop
        soundVisualizerView.contentMode = .scaleAspectFill
    }
}
