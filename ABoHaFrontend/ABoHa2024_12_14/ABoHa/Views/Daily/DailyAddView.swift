//
//  DailyAddView.swift
//  ABoHa
//
//  Created by koifish on 11/29/24.


import SwiftUI
import SVProgressHUD

struct DailyAddView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dailyVM: DailyViewModel
    @StateObject var speechVM = STTViewModel()
    @Binding var selectedTab: Tab
    
    @State private var isRecording: Bool = false
    @State private var date: Date = Date()
    @State private var weekday: String = ""
    @State private var sentiment: String = "neutral" // 초기 감정 값 설정
    @State private var content: String = ""
    @State private var image: UIImage?
    @State private var isPresented: Bool = false
    @FocusState private var isTextEditorFocused: Bool
    @State private var isSaved: Bool = false
    @State private var emotionEmoji: String = "neutral"
    @State private var debounceTimer: Timer? = nil// 기본 감정 이모티콘
    
    var body: some View {
//        ZStack {
//            // 배경 그라데이션
//            LinearGradient(gradient: Gradient(colors: [Color(hex: "E6E6FA"), Color(hex: "D8BFD8")]),
//                           startPoint: .top,
//                           endPoint: .bottom)
//            .edgesIgnoringSafeArea(.all)
//        }
        VStack{
            Text("나의 일상 기록하기")
                .font(.title2)
                .padding()
            ScrollView {
                VStack(spacing: 20) {
                    HStack{
                        // 날짜 선택
                        HStack{
                            DatePicker(
                                "",  //레이블 비워두기
                                selection: $date,
                                in: (Date().addingTimeInterval(-86400))...,
                                displayedComponents: .date
                            )
                            .labelsHidden()
//                            .datePickerStyle(.compact)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .font(.headline)
                            .environment(\.locale, Locale(identifier: "ko_KR"))
                            .onAppear {
                                // 초기 로드 시 기본 날짜 요일 업데이트
                                updateWeekday(for: date)
                            }
                            .onChange(of: date) { newDate in
                                updateWeekday(for: newDate)
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            
                            // 요일 표시
                            Text(weekday.isEmpty ? "요일 표시 없음" : "\(weekday)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        // 녹음 버튼
                        Button(action: {
                            print("Button tapped: isRecording = \(isRecording)") // 디버깅
                                speechVM.toggleRecording()
                                isRecording = !isRecording
                                isTextEditorFocused = !isRecording
                        }) {
                            HStack {
                                Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                    .foregroundColor(isRecording ? .red : .purple)
                                    .font(.largeTitle)
                                Text(isRecording ? "녹음 중지" : "녹음 시작")
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // 버튼 스타일 명시
                        .cornerRadius(10)
                        .padding(.trailing,8)
                    }

                    
                    
                    // 일기 작성 영역
                    TextEditor(text: Binding(
                        get: { content },       // Optional 값을 Unwrap하고 기본값 제공
                        set: { content = $0 }  ))
                    .focused($isTextEditorFocused)
                    .disabled(isRecording) // 녹음 중에는 비활성화
                    .frame(height: 230)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(isRecording ? .gray : .primary)
                    .font(.body)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isRecording ? Color.red : Color(hex: "#9370DB"), lineWidth: 1)
                    )
                    .onTapGesture {
                        if !isRecording {
                            isTextEditorFocused = true
                        }
                    }
                    
                    // 감정 이모티콘 표시
                    HStack{
                        Text("오늘 나의 감정은:")
                            .font(.title3)
                            .padding()
//                            .foregroundColor(.white)
                        Image("\(dailyVM.sentiment)")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    
                    
                    // 이미지 선택
                    VStack {
                        if let image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                        }
                        WideImageButton(title: "사진 선택", backgroundColor: 2) {
                            SVProgressHUD.show()
                            DispatchQueue.main.async {
                                isPresented.toggle()
                            }
                        }
                        .sheet(isPresented: $isPresented) {
                            ImagePicker(image: $image)
                                .onAppear{
                                    SVProgressHUD.dismiss()
                                }
                        }
                    }
//                    WideImageButton(title: "일기 감정 확인하기", backgroundColor: 1) {
//                        if !isRecording {
//                            guard let content = content else { return }
//                            print("현재 입력된 텍스트: \(content)")
//                            
//                            dailyVM.analyzeSentiment(text: content, completion: <#T##(String) -> Void#>)
//                        }
//                    }
                    // 일기 등록 버튼
                    WideImageButton(title: "일기 등록", backgroundColor: 1) {
                        saveDaily()
                    }
                    // 취소 버튼
                    WideImageButton(title: "취소", backgroundColor: 3) {
                        selectedTab = .dailyList
                        dismiss()
                    }

                    
                }
                .padding()
                .padding(.bottom,40)
            }
        }
        .alert("알림", isPresented: $dailyVM.isAddShowing) {
            Button("확인") {
                dailyVM.fetchDaily()
                isSaved = false // 상태 초기화
                selectedTab = .dailyList
                dismiss()
            }
        } message: {
            Text(dailyVM.message)
        }
        
        .onChange(of: speechVM.transcribedText) { newText in
            if let text = newText {
                self.content += text
                
                // 감정 분석 API 호출
                dailyVM.analyzeSentiment(text: text) { sentiment in
                    // 감정 분석 결과를 반영
                    dailyVM.sentiment = sentiment
                    dailyVM.updateEmotionEmoji(from: sentiment) // 감정 이모티콘 업데이트
                }
            }
        }
    }
        
    private func processText(_ text: String) {
        guard !text.isEmpty else { return }

        // 감정 분석 API 호출
        dailyVM.analyzeSentiment(text: text) { sentiment in
            DispatchQueue.main.async {
                dailyVM.sentiment = sentiment
                dailyVM.updateEmotionEmoji(from: sentiment)
            }
        }
    }
    
    private func updateWeekday(for date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일
        formatter.dateFormat = "EEEE"
        weekday = formatter.string(from: date)
    }
    private func saveDaily() {
                dailyVM.addDaily(image: image, contents: content, date: date.formattedDate, weekday: weekday, sentiment: dailyVM.sentiment)
        isSaved = true
        }
}
