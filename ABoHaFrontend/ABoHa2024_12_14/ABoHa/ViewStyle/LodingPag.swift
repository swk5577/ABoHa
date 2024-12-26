//
//  LodingPag.swift
//  ABoHa2024_12_5
//
//  Created by 박예린 on 12/10/24.
//

import SwiftUI

class LoadingManager : ObservableObject{
    @Published var isLoading : Bool = false {
        didSet{
            print(isLoading)
        }
    }
}

struct LodingPag: View {
    var body: some View {
        ZStack {
            // 기본 배경: 그라데이션 색상
            LinearGradient(gradient: Gradient(colors: [Color(hex: "8A2BE2"), Color(hex: "9370DB")]),
                           startPoint: .top,
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack {
                    Image("aboha")
                    /*Image("expression")*/ // 실제 로고 이미지
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Text("아주 보통의 하루")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text("평범하지만 빛나는 당신의 하루를 가득 채워보세요.")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    LodingPag()
}
