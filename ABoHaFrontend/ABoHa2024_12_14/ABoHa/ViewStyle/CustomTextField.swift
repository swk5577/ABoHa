//
//  CustomTextField.swift
//  ABoHa
//
//  Created by 박예린 on 11/19/24.
//

import SwiftUI

struct CustomTextField: View {
    var icon:String?
    var placeholder:String
    @Binding var text:String
    var isSecurde:Bool = false
    var body: some View {
        HStack{
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(.gray)
            }
            if !isSecurde{
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
            }else{
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
            }
        }.padding()
            .background(Color.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
    }
}

#Preview {
    CustomTextField(icon: "person.fill", placeholder: "사용자 아이디를 입력해주세요",text: .constant("lim4"))
    CustomTextField(icon: "lock.fill", placeholder: "비밀번호를 입력하세요", text: .constant("1234"),isSecurde: true)
}
