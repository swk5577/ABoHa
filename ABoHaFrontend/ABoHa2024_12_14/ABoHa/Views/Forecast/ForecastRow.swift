//
//  ForecastRow.swift
//  OpenApiWithSwift
//
//  Created by 이미진 on 11/8/24.
//

import SwiftUI

let sampleForecast = Forecast(id: 1732071600, main: ABoHa.Main(temp: 6.96, humidity: 64), weather: [ABoHa.Weather(main: "Clouds", description: "튼구름", icon: "04d")], date: "2024-11-20 03:00:00")

struct ForecastRow: View {
    let forecast:Forecast

    var body: some View {
        VStack(alignment: .leading) {
            Text(forecast.date)
            HStack {
                HStack {
                    Image(forecast.weather[0].icon).resizable().frame(width: 50, height: 50)
                  

                    Text(forecast.weather[0].description)
                }
                Spacer()
                VStack {
                    HStack{
                        Image(systemName: "thermometer.medium")
                        Text(String(format: "%.1f℃", forecast.main.temp))
                    }.foregroundStyle(.red)
                    HStack{
                        Image(systemName: "humidity")
                        Text("\(forecast.main.humidity)%")
                    }.foregroundStyle(.blue)
                }
            }
        }.padding()
    }
}

#Preview {
    ForecastRow(forecast: sampleForecast)
}
