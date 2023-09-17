//
//  LocationManagerDelegate.swift
//  Nanimo
//
//  Created by Lena on 2023/09/14.
//

import UIKit

protocol LocationManagerDelegate: AnyObject, UIViewController {
    func didUpdateUserLocation()
}

extension LocationManagerDelegate {
    func openSetting() {
        let alert = UIAlertController(title: "위치 서비스 사용", message: "위치서비스를 사용할 수 없습니다. 설정 > 듣는이 > 위치에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        })
        let destructiveAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(destructiveAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
