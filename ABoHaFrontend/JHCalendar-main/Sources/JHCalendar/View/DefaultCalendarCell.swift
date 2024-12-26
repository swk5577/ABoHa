//
//  SwiftUIView.swift
//  
//
//  Created by Lee Jaeho on 2021/12/19.
//

import SwiftUI

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
///Default DayView
///
///If you don't want to define CustomDayView, use DefaultCalendarCell view.
public struct DefaultCalendarCell: View {
    @EnvironmentObject var manager: CalendarManager
    var component : CalendarComponents
    var isSelected : Bool {
        manager.selectedComponent == component
    }
    //초기화구문추가
    public init(component: CalendarComponents) {
        self.component = component
    }
    
    public var body: some View {
        Button(action:{
            withAnimation(.easeInOut) {
                manager.selectedComponent = component
            }
            print(component)
        }){
            Text(String(component.day))
                .foregroundColor(isSelected ? .white : .accentColor)
                .padding(component.day < 10 ? 17:13)
                .background( Circle().fill(isSelected ? Color(hex: "9370DB") : Color(.clear)))
                .frame(maxWidth:.infinity,maxHeight: .infinity)

        }
        .buttonStyle(.borderless)
    }
}

struct DefaultCalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        DefaultCalendarCell(component: CalendarComponents(year: 2021, month: 12, day: 4))
            .environmentObject(CalendarManager())
    }
}
