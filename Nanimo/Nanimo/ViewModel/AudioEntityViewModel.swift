//
//  AudioEntityViewModel.swift
//  Nanimo
//
//  Created by Lena on 2023/07/27.
//

import Foundation
import SwiftUI

class AudioEntityViewModel {
    // TODO: dummy data는 추후 실시간 듣기를 통해 들어오는 data로 대체 예정
    var audioData: [AudioEntity] = [
        .init(kind: "자동차지나가는소리", decibel: 45.2, startHour: 13, startMinute: 22, startSecond: 23, endHour: 13, endMinute: 29, endSecond: 1, backgroundColor: .carColor),
        .init(kind: "물건 떨어지는 소리", decibel: 82.2, startHour: 12, startMinute: 2, startSecond: 1, endHour: 12, endMinute: 3, endSecond: 13, backgroundColor: .thingColor),
        .init(kind: "아기울음소리", decibel: 82.2, startHour: 1, startMinute: 32, startSecond: 1, endHour: 1, endMinute: 43, endSecond: 13, backgroundColor: .babyColor),
        .init(kind: "물건 떨어지는 소리", decibel: 82.2, startHour: 19, startMinute: 2, startSecond: 1, endHour: 19, endMinute: 3, endSecond: 13, backgroundColor: .thingColor),
        .init(kind: "자동차지나가는소리", decibel: 82.2, startHour: 23, startMinute: 4, startSecond: 1, endHour: 23, endMinute: 7, endSecond: 13, backgroundColor: .carColor),
        .init(kind: "개 짖는 소리", decibel: 82.2, startHour: 2, startMinute: 4, startSecond: 1, endHour: 2, endMinute: 13, endSecond: 13, backgroundColor: .dogColor),
        .init(kind: "바람 부는 소리", decibel: 82.2, startHour: 1, startMinute: 52, startSecond: 1, endHour: 19, endMinute: 53, endSecond: 13, backgroundColor: .babyColor),
        .init(kind: "바람 부는 소리", decibel: 82.2, startHour: 14, startMinute: 12, startSecond: 1, endHour: 14, endMinute: 23, endSecond: 13, backgroundColor: .babyColor),
        .init(kind: "바람 부는 소리", decibel: 82.2, startHour: 9, startMinute: 2, startSecond: 1, endHour: 9, endMinute: 3, endSecond: 13, backgroundColor: .babyColor),
        .init(kind: "자동차지나가는소리", decibel: 82.2, startHour: 19, startMinute: 2, startSecond: 1, endHour: 19, endMinute: 3, endSecond: 13, backgroundColor: .carColor),
        .init(kind: "자동차지나가는소리", decibel: 82.2, startHour: 19, startMinute: 2, startSecond: 1, endHour: 19, endMinute: 3, endSecond: 13, backgroundColor: .carColor),
        .init(kind: "자동차지나가는소리", decibel: 82.2, startHour: 5, startMinute: 2, startSecond: 1, endHour: 19, endMinute: 1, endSecond: 13, backgroundColor: .carColor),
        .init(kind: "자동차지나가는소리", decibel: 82.2, startHour: 21, startMinute: 42, startSecond: 1, endHour: 21, endMinute: 53, endSecond: 13, backgroundColor: .dogColor),
        .init(kind: "자동차지나가는소리", decibel: 45.2, startHour: 3, startMinute: 1, startSecond: 0, endHour: 3, endMinute: 59, endSecond: 59, backgroundColor: .carColor)
    ]
}
