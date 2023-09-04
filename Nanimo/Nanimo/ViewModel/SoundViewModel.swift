//
//  SoundViewModel.swift
//  Nanimo
//
//  Created by Lena on 2023/08/17.
//

import Foundation
import RealmSwift

class SoundViewModel {
    
    let realm = DatabaseManager.shared
    let soundData = SoundData()
    
    public func hearSound() {
        soundData.name = "피아노"
        soundData.count = 1 // 초기값
        soundData.date = "8/14"
        soundData.decibel = 20.234
        soundData.location = "경기도 수원시"
    }
    
    
}
