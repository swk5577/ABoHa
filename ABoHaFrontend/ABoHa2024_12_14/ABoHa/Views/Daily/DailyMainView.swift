//
//  MainView.swift
//  ABoHa_DailyLog

import SwiftUI

enum Tab {
    case dailyList
    case calendar
    case dailyAdd
}

struct DailyMainView: View {
    @StateObject var dailyVM = DailyViewModel()
    @State private var selectedDate: Date = Date()
    @State var selectedTab: Tab = .dailyList
    @State private var isTabBarHidden: Bool = false // TabBar 숨김 상태 관리
    
    var body: some View {
        ZStack {
            // 메인 화면
            Group {
                switch selectedTab {
                case .dailyList:
                    DailyListView()
                        .environmentObject(dailyVM)
                        .navigationTitle("나의 일상")
                        .navigationBarTitleDisplayMode(.inline)

                case .calendar:
                    CalendarView(selectedDate: $selectedDate)
                        .environmentObject(dailyVM)
                        .navigationTitle("나의 감정 기록")
                        .navigationBarTitleDisplayMode(.inline)
                    
                case .dailyAdd:
                    DailyAddView(selectedTab: $selectedTab)
                        .environmentObject(dailyVM)
                        .navigationTitle("나의 일상 기록하기")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }.onAppear{
                selectedTab = .dailyList
            }
            
            // Custom TabBar
            VStack {
                Spacer()
                HStack {
                    TabBarButton(
                        image: "list.bullet",
                        isSelected: selectedTab == .dailyList
                    ) {
                        withAnimation {
                            selectedTab = .dailyList
                        }
                    }
                    TabBarButton(
                        image: "face.smiling",
                        isSelected: selectedTab == .calendar
                    ) {
                        withAnimation {
                            selectedTab = .calendar
                        }
                    }
                    TabBarButton(
                        image: "plus.circle",
                        isSelected: selectedTab == .dailyAdd
                    ) {
                        withAnimation {
                            selectedTab = .dailyAdd
                        }
                    }
                }
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                .padding(.bottom)
                // 탭바 애니메이션
            }
            .opacity(isTabBarHidden ? 0 : 1)
        } .onTapGesture {
            withAnimation {
                isTabBarHidden.toggle()
                print(isTabBarHidden)// 탭할 때마다 상태를 토글
            }
        }
    }
}

struct TabBarButton: View {
    let title: String? = nil
    let image: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: image)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .purple : .gray)
                if let title {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(isSelected ? .purple : .gray)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    DailyMainView()
}
