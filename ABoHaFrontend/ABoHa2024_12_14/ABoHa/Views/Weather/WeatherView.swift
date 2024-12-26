//
//  WeatherView.swift
//  OpenApiWithSwift
//
//  Created by 이미진 on 11/8/24.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    @EnvironmentObject var viewModel:ForecastViewModel
    var body: some View {
        VStack {
            HStack {
                if let weather = viewModel.weather {
                    Image(weather.weather[0].icon).resizable().frame(width:100, height:100)
                    
                    VStack {
                        Text(String(format: "%.1f℃", weather.main.temp))
                            .bold()
                            .foregroundStyle(weather.main.temp>10 ? Color.red : Color.blue)
                            .font(.largeTitle)
                        HStack{
                            Image(systemName: "humidity")
                            Text("\(weather.main.humidity)%")
                        }
                    }
                }
            }.onAppear {
                viewModel.startUpdatingLocation()
            }
        }
    }
}


#Preview {
   
    WeatherView().environmentObject(ForecastViewModel())
}



