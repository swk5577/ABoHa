
import SwiftUI

struct DailyRowView: View {
    let daily: Daily
    
    var body: some View {
        VStack() {
            // 날짜, 감정, 요일 정보를 담은 HStack
            HStack(spacing: 10) {
                // 감정 아이콘
                Image(daily.sentiment, label: Text(daily.sentiment))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(daily.date)
                        .font(.subheadline)
                    //                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text(daily.weekday)
                        .font(.subheadline)
                        .foregroundColor(.purple)
                    //                        .fontWeight(.light)
                }
                Spacer()
                    .frame(maxWidth: .infinity) // 수평으로 가운데 정렬
                    .multilineTextAlignment(.center) // 텍스트도 가운데 정렬
            }
            .padding(.horizontal) // 왼쪽, 오른쪽 여백 추가
            .padding(.top, 10) // 상단 여백 추가
            
            // 일기 사진 및 내용
            VStack(alignment: .center) {
                if let phto = daily.photo ,let url = URL(string: "https://staboha.blob.core.windows.net/aboha/" + phto) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // 로딩 중 표시
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 170)
                                .frame(maxWidth: .infinity, maxHeight: 170) // 너비를 최대한으로 설정
                                .clipped() // 넘치는 부분은 잘라냄
                            
                        default:
                            EmptyView()
                        }
                    }
                }
                Text(daily.contents ?? "")
                    .font(.body)
                    .foregroundColor(.black).opacity(0.8)
                    .padding(.top, 5) // 상단 여백
                //                    .lineLimit(2) // 내용 길이에 따라 최대 3줄
            }
            .padding()
        }
        .background(Color.white) // 배경색을 흰색으로 설정
    }
}

#Preview {
    let dailyVM = DailyViewModel()
    let daily = Daily(id: 9, nickName: "yang4", contents: "It was a great day with lots of positive energy. It was a great day with lots of positive energy. It was a great day with lots of positive energy.", date: "2024-12-03", weekday: "Monday", sentiment: "neutral", photo: "") // 예시 데이터
    DailyRowView(daily: daily)
        .environmentObject(dailyVM)
}
