//
//  CheckListMainView.swift
//  ABoHa
//
//  Created by 박예린 on 11/21/24.
//

import SwiftUI
import JHCalendar

struct CheckListMainView: View {
    var manager = CalendarManager(mode:.Week)
    let CheckDataVM = CheckDataModel()
    
    var body: some View {
        
        NavigationView {
            ZStack{
                VStack{
                    JHCalenderTest()
                    CheckListView()
                    .environmentObject(CheckDataVM)
                    
                }.environmentObject(manager)

                    VStack{
                        Spacer()
                        NavigationLink(destination: CheckListAdd()) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(Color(hex: "9370DB"))
                                .background(Circle().fill(Color(.white)))
                        }
                            
                    }
            }
        }
    }
}

#Preview {
    let CheckDataVM = CheckDataModel()
    CheckListMainView().environmentObject(CheckDataVM)
}
