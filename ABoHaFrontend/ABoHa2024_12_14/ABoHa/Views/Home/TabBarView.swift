//
//  TabBarView.swift
//  ABoHa2024_12_5
//
//  Created by 박예린 on 12/5/24.
//
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var checkDataVM : CheckDataModel
    var body: some View {
        
        TabView() {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.system(size: 20)) // 아이콘 크기 조정
                        Text("홈")
                            .font(.caption) // 탭 텍스트 스타일 조정
                            .foregroundColor(.primary)
                    }
                }
            
            CheckListMainView()
                .tabItem {
                    VStack {
                        Image(systemName: "checklist")
                            .font(.system(size: 20))
                        Text("투두 리스트")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            
            DailyMainView()
                .tabItem {
                    Image(systemName: "square.and.pencil.circle.fill")
                    Text("일기목록")
                }
            
            ForecastView(city: "seoul")
                .tabItem {
                    VStack {
                        Image(systemName: "cloud.sun.fill")
                            .font(.system(size: 20))
                        Text("날씨")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            
            
            
            MyAbohaView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: 20))
                        Text("My 아보하")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            
        }
        .accentColor(Color(hex: "#9370DB")) // 선택된 탭 색상 설정
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.systemGroupedBackground // 탭 바 배경 색상 설정
        }
    }
}

#Preview {
    TabBarView()
        .environmentObject(ForecastViewModel())
        .environmentObject(CheckDataModel())
}
