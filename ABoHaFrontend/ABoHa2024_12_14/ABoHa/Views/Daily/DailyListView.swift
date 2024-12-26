//
//  DailyListView.swift
//  ABoHa
//
//  Created by koifish on 11/29/24.
//

import SwiftUI

struct DailyListView: View {
    @EnvironmentObject var dailyVM: DailyViewModel
    @State private var isAddingDaily = false  // 추가 뷰 표시 여부
    @State var date: Date = Date()
    @State var weekday: String = ""
    
    var body: some View {
        VStack {
            Text("나의 일상")
                .font(.title2)
                .padding()
            // 일기 목록 리스트
            List(dailyVM.dailys) { daily in
                DailyRowView(daily: daily)
                    .background(RoundedRectangle(cornerRadius: 10)) // 아이템 배경 추가
                    .padding(.horizontal) // 리스트 항목의 가로 간격 추가
                //                            .lineLimit(5) // 내용 길이에 따라 최대 3줄
            }
            .listStyle(PlainListStyle())
            .onAppear {
                dailyVM.fetchDaily() // 일기 데이터 불러오기
            }
            Spacer()
        }
    }
}

#Preview {
    let dailyVM = DailyViewModel()
    DailyListView()
        .environmentObject(dailyVM)
}
