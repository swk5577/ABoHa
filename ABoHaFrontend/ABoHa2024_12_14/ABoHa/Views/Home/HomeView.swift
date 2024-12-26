//
//  HomeView.swift
//  ABoHa
//
//  Created by 이미진 on 11/20/24.
//
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userVM: UserViewModel // 사용자 상태 관리
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false // 알림창 표시 상태 관리
    @State var selectedTab: Tab = .dailyAdd
    @State private var navigateToDailyAdd = false
    
    var body: some View {
        
        if userVM.isLoggedIn {
            NavigationStack {

                VStack{
                    SectionCard {
                        WeatherView()
                    }
                    
                    SectionCard {
                        WideImageButton(title: "일기 바로 작성하기", backgroundColor: 1) {
                            navigateToDailyAdd = true
                        }
                        .navigationDestination(isPresented: $navigateToDailyAdd) {
                            DailyAddView(selectedTab: $selectedTab)
                                .navigationBarBackButtonHidden(true) // 뒤로가기 버튼 숨김
                        }
                    }
                    SectionCard{
                            HStack{
                                Text("Today Todo List")
                                    .padding(.leading)
                                Spacer()
                            }
                            CheckListView()
                                .padding(.horizontal)
                        }
                }
                
            }
        }else {
            EntryView()// 로그아웃 후 EntryView로 이동
        }
    }
    
    
    // SectionCard: 공통 카드 스타일 컴포넌트?
    struct SectionCard<Content: View>: View {
        let content: Content
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            VStack {
                content
            }
            .padding()
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2) // 그림자
        }
    }
}
