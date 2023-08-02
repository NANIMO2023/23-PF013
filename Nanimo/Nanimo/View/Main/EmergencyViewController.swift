//
//  EmergencyViewController.swift
//  Nanimo
//
//  Created by Lena on 2023/08/02.
//

import UIKit

// refernece: https://github.com/leoiphonedev/PulseAnimation-Swift.git
class EmergencyViewController: UIViewController {
    
    private var minuteLabel = UILabel()
    private var soundNotificationLabel = UILabel()
    
    var pulseLayers = [CAShapeLayer]()
    private var backgroundImage = UIImageView(image: UIImage(named: "emergency-background.png"))
    private var centerCircle = CustomCircleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        [backgroundImage,minuteLabel, soundNotificationLabel].forEach { view.addSubview($0) }
//        centerCircle.layer.cornerRadius = centerCircle.frame.width / 2
        setLabel()
        createPulse()
        configureLayout()
    }
    
    private func createPulse() {
 
        for _ in 0...4 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: screenWidth / 2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 10.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = CGPoint(x: screenWidth / 2.0, y: screenHeight / 2.0)

            backgroundImage.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.animatePulse(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.animatePulse(index: 2)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.animatePulse(index: 3)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.animatePulse(index: 4)
                        }
                    }
                }
            }
        }
    }
    
    func animatePulse(index: Int) {
        pulseLayers[index].strokeColor = UIColor.white.cgColor

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 2.0
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }
    
    private func configureLayout() {
        backgroundImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        minuteLabel.anchor(top: backgroundImage.topAnchor, leading: backgroundImage.leadingAnchor, paddingTop: 85, paddingLeading: 21)
        minuteLabel.setHeight(height: 24)
        
        soundNotificationLabel.anchor(top: minuteLabel.bottomAnchor, leading: backgroundImage.leadingAnchor, paddingTop: 8, paddingLeading: 21)
    }
    
    private func setLabel() {
        minuteLabel.setLabel(labelText: " 1분 전부터 ", backgroundColor: .black, weight: .medium, textSize: 16, labelColor: .white)
        soundNotificationLabel.setLabel(labelText: "사이렌이 울리고 있어요", backgroundColor: .clear, weight: .bold, textSize: 32, labelColor: .white)
    }
}
