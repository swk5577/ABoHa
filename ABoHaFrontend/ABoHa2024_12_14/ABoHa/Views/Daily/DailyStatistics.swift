//
//  DailyStatistics.swift
//  ABoHa2024_12_5
//
//  Created by 박예린 on 12/10/24.
//

import SwiftUI

struct DailyStatistics: View {
    var selectedDate: String
    @EnvironmentObject var dailyVM : DailyViewModel
    var filteredDailys: [Daily] {
        dailyVM.dailys.filter { $0.date.hasPrefix(selectedDate) }
    }

    var body: some View {
        
        //감정 통계치
        HStack{
            let frameSize:Int = 70
            VStack{
                Image("positive")
                    .resizable()
                    .frame(width: CGFloat(frameSize), height: CGFloat(frameSize))
                    .padding(.horizontal)
                Text("\(filterSentiments(senti: "positive"))%")
                
            }

            VStack {
                Image("neutral")
                    .resizable()
                    .frame(width: CGFloat(frameSize), height: CGFloat(frameSize))
                    .padding(.horizontal)
                Text("\(filterSentiments(senti: "neutral"))%")
            }
            VStack {
                Image("negative")
                    .resizable()
                    .frame(width: CGFloat(frameSize), height: CGFloat(frameSize))
                    .padding(.horizontal)
                Text("\(filterSentiments(senti: "negative"))%")
            }
        }.onAppear{
            print(filteredDailys.count)
        }
    }
    
    //퍼센트 계산
    func filterSentiments(senti : String) -> Int {
        let centcount = filteredDailys.filter { $0.sentiment == senti }
        guard !filteredDailys.isEmpty else {
            return 0
        }
        let sentipustent = CGFloat(centcount.count)/CGFloat(filteredDailys.count)
        return Int(sentipustent * 100)
    }

}

//#Preview {
//    DailyStatistics()
//}
