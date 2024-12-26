//
//  CheckListView.swift
//  ABoHa
//
//  Created by 박예린 on 11/19/24.
//

import SwiftUI
import JHCalendar

func dateToStr (date:Date)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyy-MM-dd"
    
    let dateString = dateFormatter.string(from: date)
    return dateString
}


struct CheckListView: View {
    @EnvironmentObject var checkDataVM : CheckDataModel
    @EnvironmentObject var manager : CalendarManager
    @State var selectedDate:Date = Date()
    //숫자 변환
    
    var body: some View {
        
        //        뿌리기
        if checkDataVM.isFetchError {
            Text(checkDataVM.message).padding(.vertical)
        }
        List(checkDataVM.filterData) {
            checklist in
            CheckRow(checkList: checklist,CheckDataVM: checkDataVM)
                .swipeActions {
                    Button {
                        checkDataVM.deleteCheckList(id: checklist.id)
                    } label: {
                        Text("Delete")
                    }
                }
        }
        .listStyle(PlainListStyle())
        .onAppear{
                checkDataVM.getCheckList()
        }
        .onChange(of: manager.selectedComponent.date) {
            checkDataVM.isFetchError = false
            checkDataVM.seletedDate = manager.selectedComponent.date
            checkDataVM.filterData(for: dateToStr(date: manager.selectedComponent.date))
        }
    }
}

#Preview {
    let CheckDataVM = CheckDataModel()
    CheckListView().environmentObject(CheckDataVM)
}
