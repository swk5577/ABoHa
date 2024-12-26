//
//  CheckListAdd.swift
//  ABoHa
//
//  Created by 박예린 on 11/19/24.
//

import SwiftUI
import SVProgressHUD

struct CheckListAdd: View {
    @EnvironmentObject var CheckDataVM : CheckDataModel
    @Environment(\.dismiss) private var dismiss
    
    @State var contents = ""
    @State var isOn = true
    @State var startDay : Date = Date()
    @State var cycle = "매월"
//    @State var completeDay = ""
    @State var showCancelAlert = false
    @State var showSaveAlert = false
    @State var seletedDate:Date = Date()
    
    var body: some View {
        VStack{
            ScrollView{
                CustomTextField( placeholder: "목표를 적어보세요!", text: $contents)
//                HStack{
//                    WideImageButton(title: "매일", backgroundColor: cycle == "매일" ? .blue : .gray ) {
//                        cycle = "매일"
//                    }
//                    WideImageButton(title: "매주", backgroundColor: cycle == "매주" ? .blue : .gray ) {
//                        cycle = "매주"
//                    }
//                    WideImageButton(title: "매월", backgroundColor: cycle == "매월" ? .blue : .gray ) {
//                        cycle = "매월"
//                    }
//
//                } //HStack1
//                .padding()
                
                TimeDatePickerView(seletedDate: $seletedDate,cycle: $cycle)
                    .padding(.horizontal)
                    .padding(.vertical,10)
                HStack{
                    Toggle(isOn: $isOn) {
                        Text("알람여부")
                    }.toggleStyle(SwitchToggleStyle(tint: Color(hex: "#9370DB")))
                }
                .padding()
                .padding(.vertical,10)
            }//scrollview
        }//Vstack
        Spacer()
        // --------------하단 저장 취소 버튼
        ZStack(alignment: .bottom) {
            HStack{
//                Button("취소") {
//                    showCancelAlert = true
//                }.alert("입력을 취소 하시겠습니까", isPresented: $showCancelAlert) {
//                    Button("취소", role: .cancel){}
//                    Button("확인", role: .destructive){dismiss()}
//                }
//                Text("/")
                WideImageButton(title: "저장", backgroundColor: 1) {
                    showSaveAlert = true
                }.alert("저장 하시겠습니까", isPresented: $showSaveAlert) {
                    Button("취소", role: .cancel){}
                    
                    Button("저장", role: .destructive){
                        CheckDataVM.addCheckList(isOn: isOn,startDay: formattedYearMonth(date:startDay), alramDate: formattedYearMonth(date:seletedDate), alramTime: formattedTime, contents: contents)
                        CheckDataVM.seletedDate = seletedDate
                        SVProgressHUD.show()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss()
                            SVProgressHUD.dismiss()
                        }
                    }
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity)
            .font(.title2)
        }//Zstack
        .padding(.bottom)
    }
    var formattedDate:DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    //날짜 문자변환
    func formattedYearMonth(date:Date)-> String {
        let formatter = formattedDate
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: date)
    }
    //시간 문자 변환
    private var formattedTime: String {
        let formatter = formattedDate
        formatter.dateFormat = "HH:mm" // 시간만 표시
        return formatter.string(from: seletedDate)
    }
    
    
}

#Preview {
    CheckListAdd()
}
