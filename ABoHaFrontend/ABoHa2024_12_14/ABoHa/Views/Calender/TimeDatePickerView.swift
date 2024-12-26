//
//  TimeDatePickerView.swift
//  ABoHa
//
//  Created by 박예린 on 11/20/24.
//

import SwiftUI

struct TimeDatePickerView: View {
    @Binding var seletedDate : Date
    @Binding var cycle:String
    @State var seletweek : [String] = []
    var body: some View {
        VStack{
            switch cycle {
            case "매일" :
                DatePicker("시간 선택", selection: $seletedDate, displayedComponents: .hourAndMinute)
                    .environment(\.locale, Locale(identifier: "ko_KR"))
            case "매주" :
                VStack{
                    Text("요일 선택")
                    HStack{
                        
                        
                        ForEach(WeekDay.allCases, id: \.self) { weekname in
                            
                            Button {
                                if self.seletweek.contains(weekname.name){
                                    self.seletweek.removeAll{ $0 == weekname.name}
                                }else{
                                    seletweek.append(weekname.name)
                                }
                            } label: {
                                Text(weekname.name)
                                    .padding()
                                    .background(Circle().fill(seletweek.contains(weekname.name) ? Color.blue : Color.gray))
                                    .foregroundColor(.white)
                                
                            }
                            
                            
                        }
                    }
                }
            default :
                DatePicker("날짜선택",
                           selection: $seletedDate,
                           in: (Date().addingTimeInterval(-86400))...)
                
                    .environment(\.locale, Locale(identifier: "ko_KR"))
            }
            
        }
    }
}



#Preview {
    TimeDatePickerView(seletedDate:.constant(Date()),cycle: .constant("매일"))
    TimeDatePickerView(seletedDate:.constant(Date()),cycle: .constant("매주"))
    TimeDatePickerView(seletedDate:.constant(Date()),cycle: .constant("매월"))
}
