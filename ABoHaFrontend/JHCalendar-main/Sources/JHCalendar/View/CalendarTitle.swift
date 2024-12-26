//
//  SwiftUIView.swift
//  
//
//  Created by Lee Jaeho on 2021/12/19.
//

import SwiftUI

struct CalendarTitle : View {
    
    var comp : CalendarComponents
    
    var body: some View {
        HStack{
            Text(formattedDate)
        }
        .font(.title2.bold())
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국 로케일
        formatter.dateFormat = "yyyy년 M월" // 한국식 날짜 포맷
        return formatter.string(from: comp.date)
    }
}

struct CalendarTitle_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTitle(comp: CalendarComponents(year: 2021, month: 12, day: 4))
    }
}
