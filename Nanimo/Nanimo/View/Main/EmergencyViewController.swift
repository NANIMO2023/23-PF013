//
//  EmergencyViewController.swift
//  Nanimo
//
//  Created by Lena on 2023/08/02.
//

import UIKit
import CoreImage

// refernece: https://github.com/leoiphonedev/PulseAnimation-Swift.git
class EmergencyViewController: UIViewController {
    
    private var minuteLabel = UILabel()
    private var soundNotificationLabel = UILabel()
    
    var pulseLayers = [CAShapeLayer]()
    private var backgroundImage = UIImageView(image: UIImage(named: "emergency-background.png"))
    
    private var notifyButton: UIButton = {
        let button = UIButton()
        button.makeRounded(radius: 35)
        button.createButton(title: "주변에 알리기", titleSize: 28, titleColor: .white, backgroundColor: .black)
        button.layer.shadowRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(tapNotifyButton(_:)), for: .touchUpInside)
        button.layer.zPosition = 1.0
        button.isEnabled = true
        return button
    }()
    
//    private var foldView = FoldView()
    var emergencyIdentifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await createPulse() }
        
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        
        [minuteLabel, soundNotificationLabel, notifyButton].forEach { backgroundImage.addSubview($0) }
        
        setLabel()
//        setButton()
        configureLayout()
    }
    
    private func createPulse() async {
        for _ in 0...4 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: screenWidth / 2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            let pulseLayer = CAShapeLayer()

            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 8.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.opacity = 0.7
            
            pulseLayer.position = CGPoint(x: screenWidth / 2.0, y: screenHeight / 2.0)
            
            /*
            if let filter = CIFilter(name: "CIGaussianBlur") {
                filter.name = "myFilter"
                pulseLayer.filters = [filter]
                pulseLayer.setValue(1, forKeyPath: "backgroundFilters.myFilter.inputRadius")
            }
             */
            
            view.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        Task {
            await animatePulses()
        }
    }

    func animatePulses() async {
        await animatePulse(index: 0)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
        
        await animatePulse(index: 1)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
        
        await animatePulse(index: 2)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
        
        await animatePulse(index: 3)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
        
        await animatePulse(index: 4)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
    }

    func animatePulse(index: Int) async {
        pulseLayers[index].strokeColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 3.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 2.0
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 3.0
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.1
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }
    
    private func configureLayout() {
        backgroundImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        minuteLabel.anchor(top: backgroundImage.topAnchor, leading: backgroundImage.leadingAnchor, paddingTop: 85, paddingLeading: 21)
        minuteLabel.setHeight(height: 24)
        
        soundNotificationLabel.anchor(top: minuteLabel.bottomAnchor, leading: backgroundImage.leadingAnchor, paddingTop: 8, paddingLeading: 21)
        
        notifyButton.centerX(inView: backgroundImage)
        notifyButton.setHeight(height: 68)
        notifyButton.setWidth(width: 197)
        notifyButton.anchor(bottom: backgroundImage.bottomAnchor, paddingBottom: 200)
        
        /*
        foldView.centerX(inView: backgroundImage)
        foldView.setHeight(height: 51)
        foldView.anchor(top: notifyButton.bottomAnchor, bottom: view.bottomAnchor, paddingTop: 32, paddingBottom: 140)
         */
    }
    
    private func setLabel() {
        minuteLabel.setLabel(labelText: " 1분 전부터 ", backgroundColor: .black, weight: .medium, textSize: 16, labelColor: .white)
        soundNotificationLabel.setLabel(labelText: "\(emergencyIdentifier) 소리가 나고있어요", backgroundColor: .clear, weight: .bold, textSize: 32, labelColor: .white)
    }
    /*
    private func setButton() {
        notifyButton.makeRounded(radius: 35)
        notifyButton.createButton(title: "주변에 알리기", titleSize: 28, titleColor: .white, backgroundColor: .black)
        notifyButton.layer.shadowRadius = 20
        notifyButton.layer.shadowColor = UIColor.black.cgColor
        notifyButton.addTarget(self, action: #selector(tapNotifyButton(_ :)), for: .touchUpInside)
        notifyButton.isUserInteractionEnabled = true
        notifyButton.layer.zPosition = 1.0
    }
*/
    @objc func tapNotifyButton(_ sender: UIButton) {
        print("연락처 실행")
        /*
        if let url = URL(string: "tel://") {
            UIApplication.shared.open(url)
        }
         */
    }
}
