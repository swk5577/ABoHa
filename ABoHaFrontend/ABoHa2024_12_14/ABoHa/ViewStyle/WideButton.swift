//
//  WideButton.swift
//  ABoHa
//
//  Created by 박예린 on 11/19/24.
//

import SwiftUI

struct WideImageButton: View {
    var icon:String?
    var title:String
    var backgroundColor:Int
    var borderColor:Color = .clear
    var textColor:Color = .white
    var action:()->Void
    var body: some View {
            Button {
                action()
            } label: {
                if let icon {
                    Image(systemName: icon).foregroundStyle(textColor)
                }
                Text(title)
                    .font(.headline)
                    .foregroundStyle(textColor)
            }
            .frame(maxWidth: .infinity)
            //공간 모두 차지
            .padding()
            .background(
                {
                    switch backgroundColor {
                    case 1:
                        return Color(hex: "#9370DB")
                    case 3:
                        return Color(hex: "#FF6347")
                    default:
                        return Color(hex: "#CBB9E5")
                    }
                }()
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 2))
            .padding(.horizontal)

        }
}

//핵사코드 변환
extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}


#Preview {
//    let colorArr = ["#9370DB","#CBB9E5", "#DACFF0", "#E6DBF5", "#A593D8",]
    ScrollView{
//        ForEach(colorArr,id: \.self) { color in
            WideImageButton(icon: "person.fill", title: "1", backgroundColor: 1) {}
        WideImageButton(icon: "person.fill", title: "2", backgroundColor: 2,textColor: Color(hex: "9370DB")) {}
        }
//    }
}
