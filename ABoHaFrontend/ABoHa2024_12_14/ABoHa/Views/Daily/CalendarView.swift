import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dailyVM: DailyViewModel
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss // dismiss 환경 변수
//    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack{
            Text("나의 감정 기록")
                .font(.title2)
                .padding()
                ScrollView { // ScrollView로 콘텐츠를 감싸기
                    VStack{
                        // 수정된 년/월 선택기
                        YearMonthPickerView(selectedDate: $selectedDate)
                            .padding(.horizontal, 20)
                            .animation(.easeInOut, value: selectedDate) // 애니메이션 최적화
                            DailyStatistics(selectedDate:String(selectedDate.formattedDate.prefix(7)))
                        
                        // 감정 이모티콘 섹션
                        let monthlySentiments = getMonthlySentiments()
                        
                        //감정 뿌리기 시작하는 부분
                        if !monthlySentiments.isEmpty {
                            monthlySentimentsView(sentiments: monthlySentiments)
                        } else {
                            Text("이번 달에 기록된 감정이 없습니다.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                        // 선택된 달의 일기 리스트
//                        VStack(alignment: .leading, spacing: 10) {
//                            ForEach(dailyVM.dailys.filter {
//                                $0.date.hasPrefix(selectedDate.formattedDate.prefix(7))
//                            }, id: \.id) { daily in
//                                VStack(alignment: .leading, spacing: 5) {
//                                    HStack {
//                                        ForEach(daily.sentiment.split(separator: ","), id: \.self) { sentiment in
//                                            Image(String(sentiment))
//                                                .resizable()
//                                                .frame(width: 20, height: 20)
//                                                .padding(2)
//                                        }
//                                        // 날짜
//                                        Text(daily.date)
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
//                                    }
//                                    
//                                    // 내용
//                                    Text(daily.contents)
//                                        .font(.body)
//                                        .foregroundColor(.black)
//                                        .padding(.vertical, 2)
//                                        .lineLimit(2)
//                                }
//                                .padding()
//                                .background(Color(UIColor.systemGray6))
//                                .cornerRadius(8)
//                            }
//                        }
//                        .padding(.horizontal)
                    }
                }
        }
    }
    func getMonthlySentiments() -> [String] {
        return dailyVM.dailys.filter {
            $0.date.hasPrefix(selectedDate.formattedDate.prefix(7))
        }.map { $0.sentiment }
    }
    func monthlySentimentsView (sentiments: [String]) -> some View{
        VStack(alignment: .leading, spacing: 8) {
            Text("이번 달의 감정")
                .font(.headline)
                .foregroundColor(.purple)
                .padding(.horizontal)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7),
                spacing: 3
            ) {
                // 인덱스를 사용하여 중복 감정 이모티콘 처리
                ForEach(Array(sentiments.enumerated()), id: \.offset) { _, sentiment in
                    Image(sentiment)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            }
            .padding(.horizontal)
        }
    }
}



extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

#Preview {
    @Previewable @State var selectedDate = Date()
    let dailyVM = DailyViewModel()
    CalendarView(selectedDate: $selectedDate)
        .environmentObject(dailyVM)
}
