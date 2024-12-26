//
//  JHCalenderTest.swift
//  ABoHa
//
//  Created by 박예린 on 11/20/24.
//

import SwiftUI
import JHCalendar

struct JHCalenderTest : View {
    @EnvironmentObject var manager:CalendarManager

    public var body : some View {
      
        JHCalendar{ comp in
            DefaultCalendarCell(component: comp)
        }
        .customWeekdaySymbols(symbols: ["일","월","화","수","목","금","토"])
        .environmentObject(manager)
       
        Button {
            manager.setMode()
        } label: {
            HStack{
                if (manager.mode == .Month){
                    Image(systemName: "chevron.up")
                    Text("접기")
                }else {
                    Image(systemName: "chevron.down")
                    Text("펼치기")
                }
            }
                .foregroundStyle(Color(hex: "9370DB"))
                .fontWeight(.bold)
        }.onAppear{
            manager.selectedComponent = CalendarComponents.current
        }

    }
}
    #Preview {
        var manager = CalendarManager(mode:.Week)
        JHCalenderTest().environmentObject(manager)
    }
