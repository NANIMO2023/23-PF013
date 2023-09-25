//
//  AudioPointMarkView.swift
//  Nanimo
//
//  Created by Lena on 2023/07/27.
//

import SwiftUI
import Charts

struct AudioPointMarkView: View {
    
    @State private var viewModel = AudioEntityViewModel()
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.audioData) { audio in
                    RectangleMark(
                        xStart: .value("Start Minute", audio.startMinute),
                        xEnd: .value("End Minute", audio.endMinute),
                        y: .value("Start Hour", audio.startHour)
                        
                    )
                    .cornerRadius(20)
//                    .foregroundStyle(Color(uiColor: .customChartGreen))
                    .foregroundStyle(audio.backgroundColor)
//                    .opacity(0.5)
                    
                }
            }
            .chartYScale(domain: [0, 23])
            .chartXScale(domain: [0, 59])
            
        }
        .frame(height: 300)
        .padding()
    }
}

struct AudioPointMarkView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPointMarkView()
    }
}
