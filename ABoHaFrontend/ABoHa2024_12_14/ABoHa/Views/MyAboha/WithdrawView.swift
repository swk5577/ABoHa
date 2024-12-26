//
//  WithdrawView.swift
//  ABoHa
//
//  Created by 이미진 on 11/29/24.
//

import SwiftUI

struct WithdrawView: View {
    @Environment(\.presentationMode) var presentation
    @State var password:String = ""
    
    var body: some View {
        VStack {
            Text("회원 탈퇴")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text("정말로 탈퇴하시겠습니까? 회원 탈퇴를 원하시면 비밀번호를 입력해 주세요.").padding()
            CustomTextField(icon: "lock.fill", placeholder: "비밀번호 입력", text: $password, isSecurde: true).padding()
            
            HStack{
                Button(action: {
                    presentation.wrappedValue.dismiss()
                }) {
                    Text("탈퇴하기").bold()
                }
                .frame(width: 150, height: 30, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 40).fill(Color.init(hex: "#9370DB")))
                .font(.system(size: 16))
                .foregroundColor(Color.white)
                
            Button(action: {
                presentation.wrappedValue.dismiss()
            }) {
                Text("돌아가기").bold()
            }
            .frame(width: 150, height: 30, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 40).stroke(Color.init(hex: "#9370DB"), lineWidth: 1))
            .font(.system(size: 16))
            .foregroundColor(Color.init(hex: "#9370DB"))
            }
        }
    }
}

#Preview {
    WithdrawView()
}
