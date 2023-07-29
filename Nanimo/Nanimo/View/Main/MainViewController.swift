//
//  MainViewController.swift
//  Nanimo
//
//  Created by Lena on 2023/07/12.
//

import SwiftUI

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var minuteLabel = UILabel()
    private var soundNotificationLabel = UILabel()
    private var todayAudioLabel = UILabel()
    
    private var backgroundGradientBlockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: gradientGreenBlockImage)
        return imageView
    }()
    
    let dailyAudioChartHostingView = UIHostingController(rootView: AudioPointMarkView())
    
    private var detailButton: UIButton = {
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
        
        makeHostingViewToUIView()
        [minuteLabel, soundNotificationLabel].forEach { backgroundGradientBlockImage.addSubview($0) }
        [backgroundGradientBlockImage, todayAudioLabel, detailButton, audioStackView].forEach { view.addSubview($0) }
        setLabel()
        configureLayout()
    }
    
    // MARK: - methods for layouts
    
    private func setLabel() {
        backgroundGradientBlockImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        minuteLabel.setLabel(labelText: " 40분 전부터 ", backgroundColor: .black, weight: .medium, textSize: 16, labelColor: .white)
        soundNotificationLabel.setLabel(labelText: "일상 소음이 들리고 있어요", backgroundColor: .clear, weight: .bold, textSize: 24, labelColor: .black)
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
        
        soundNotificationLabel.anchor(top: minuteLabel.bottomAnchor, leading: backgroundGradientBlockImage.leadingAnchor, paddingTop: 8, paddingLeading: 21)
        
        dailyAudioChartHostingView.view.centerX(inView: view)
        dailyAudioChartHostingView.view.setWidth(width: view.bounds.width * 0.98)
        dailyAudioChartHostingView.view.anchor(top: soundNotificationLabel.bottomAnchor, paddingTop: 27)
        
        todayAudioLabel.anchor(top: dailyAudioChartHostingView.view.bottomAnchor, leading: view.leadingAnchor, paddingTop: 25, paddingLeading: 19)
        
        detailButton.anchor(top: dailyAudioChartHostingView.view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 25, paddingTrailing: 19)
        
        audioStackView.anchor(top: todayAudioLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 5, paddingLeading: 18)
    }
}
