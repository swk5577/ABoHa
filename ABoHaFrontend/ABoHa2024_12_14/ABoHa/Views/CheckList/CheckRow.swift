//
//  CheckListRow.swift
//  ABoHa
//
//  Created by 박예린 on 11/19/24.
//

import SwiftUI
import UserNotifications

let sampldata = ABoHa.CheckList(id: 8, nickName: "lin", isOn: false, isComplete: false, startDay: "Wed Nov 27 2024 16:46:21 GMT+0900 (Korean Standard Time)",alramDate: "",alramTime: "6:30", contents: "달리기")

struct CheckRow: View {
    @State var checkList : CheckList
    @ObservedObject var CheckDataVM : CheckDataModel
    
    var body: some View {

        HStack{
            VStack{
                Text(checkList.alramTime)
                Image(systemName: checkList.isOn ? "bell.fill" : "bell.slash.fill")
                    .foregroundColor(checkList.isOn ? .yellow : .gray)
            }.onTapGesture {
                checkList.isOn = !checkList.isOn
                CheckDataVM.patchCheckList(id: checkList.id, isOn: checkList.isOn, isComplete: checkList.isComplete)
                //알람 트리거
                if checkList.isOn {
                    scheduleNotification()
                }else{
                    cancelNotification()
                }
            }
            .padding(.trailing)
            Text(checkList.contents).font(.title3)
                .strikethrough(checkList.isComplete, color: .gray)
                .foregroundColor(checkList.isComplete ? .gray: .black)
            Spacer()
            Group {
                if checkList.isComplete {
                    Image("check")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 5, height: 5)
                        .padding(.horizontal,10)
                }
            }
            .onTapGesture {
                checkList.isComplete.toggle()
                CheckDataVM.patchCheckList(id: checkList.id, isOn: checkList.isOn, isComplete: checkList.isComplete)
            }

        }
    }
    //알람 설정
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "체크리스트를 확인하세요"
        content.body = checkList.contents
        content.sound = .default
        
        var alarmTime = DateComponents()
        let timeSplit = checkList.alramTime.split(separator: ":")
        alarmTime.hour = Int(timeSplit[0])
        alarmTime.minute = Int(timeSplit[1])
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarmTime, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(checkList.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){
            err in
            if let err {
                print("알림설정에 실패 했습니다",err)
            }else{
                print("알림설정에 성공 했습니다.")
            }
        }
    }
    //알람취소
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(checkList.id)"])
        print("알람이 삭제되었습니다")
    }
}


#Preview {
    CheckRow(checkList: sampldata, CheckDataVM: CheckDataModel())
}
