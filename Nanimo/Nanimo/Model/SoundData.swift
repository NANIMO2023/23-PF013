//
//  SoundData.swift
//  Nanimo
//
//  Created by Lena on 2023/08/17.
//

import Foundation
import RealmSwift

class SoundData: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var count: Int = 0
    @objc dynamic var decibel: Double = 0.0
}
