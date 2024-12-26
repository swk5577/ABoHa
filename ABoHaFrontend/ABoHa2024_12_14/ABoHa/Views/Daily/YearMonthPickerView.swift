//
//  YearMonthPickerView.swift
//  ABoHa2024_12_5
//
//  Created by koifish on 12/9/24.
//



import SwiftUI

struct YearMonthPickerView: View {
    @Binding var selectedDate: Date
    
    let months: [String] = {
        var monthSymbols: [String] = []
        
        for monthIndex in 1...12 {
            var dateComponent = DateComponents()
            dateComponent.year = 2024 // 임의의 연도 설정
            dateComponent.month = monthIndex
            
            if let date = Calendar.current.date(from: dateComponent) {
                // monthName() 메서드를 사용하여 월 이름을 가져오기
                let monthString = date.monthName() // 한국식 "1월", "2월" 등
                monthSymbols.append(monthString)
            }
        }
        return monthSymbols
    }()
    
    var body: some View {
        VStack {
            // Year Picker
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 24.0)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.year = -1
                        selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                    }
                
                Text(String(selectedDate.year()))
                    .fontWeight(.bold)
                    .transition(.move(edge: .trailing))
                
                Image(systemName: "chevron.right")
                    .frame(width: 24.0)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.year = 1
                        selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                    }
            }
            
            // Month Picker
            HStack(spacing: 15) {
                Image(systemName: "chevron.left")
                    .frame(width: 24.0)
                    .onTapGesture {
                        if let currentIndex = months.firstIndex(of: selectedDate.monthName()), currentIndex > 0 {
                            var dateComponent = DateComponents()
                            dateComponent.month = -1
                            selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                        }
                    }
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(months, id: \.self) { month in
                                Text(month)
                                    .font(.headline)
                                    .frame(width: 60, height: 33)
                                    .bold()
                                    .background(month == selectedDate.monthName() ? Color.purple : Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        var dateComponent = DateComponents()
                                        dateComponent.day = 1
                                        dateComponent.month = months.firstIndex(of: month)! + 1
                                        dateComponent.year = Int(selectedDate.year())
                                        selectedDate = Calendar.current.date(from: dateComponent)!
                                    }
                            }
                        }
                    }.onAppear {
                            proxy.scrollTo(selectedDate.monthName(), anchor: .center)
                    }
                }

                
                Image(systemName: "chevron.right")
                    .frame(width: 24.0)
                    .onTapGesture {
                        if let currentIndex = months.firstIndex(of: selectedDate.monthName()), currentIndex < months.count - 1 {
                            var dateComponent = DateComponents()
                            dateComponent.month = 1
                            selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                        }
                    }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}

// Date Extension for Year and Month Name
extension Date {
    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func monthName() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월"
        return formatter.string(from: self)
    }
}
