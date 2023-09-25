//
//  AudioEntity.swift
//  Nanimo
//
//  Created by Lena on 2023/07/27.
//

import Foundation
import SwiftUI

struct AudioEntity: Identifiable {
    var id = UUID().uuidString
    
    let kind: String
    let decibel: Double
    
    let startHour: Int
    let startMinute: Int
    let startSecond: Int
    
    let endHour: Int
    let endMinute: Int
    let endSecond: Int
    
    let backgroundColor: Color
}
