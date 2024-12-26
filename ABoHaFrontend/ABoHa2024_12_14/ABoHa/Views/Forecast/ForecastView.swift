//
//  ForecastView.swift
//  OpenApiWithSwift
//
//  Created by 이미진 on 11/8/24.
//

import SwiftUI
import CoreLocation

struct ForecastView: View {
    @State var city = ""
    @EnvironmentObject var viewModel:ForecastViewModel
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                SearchBar(searchText: $city) {
                    viewModel.getForecast(city: city)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let firstForecast = viewModel.forecasts?.first {
                            withAnimation {
                                proxy.scrollTo(firstForecast.id, anchor: .top)
                            }
                        }
                    }
                }.padding()
                WeatherView()
                if let forecasts = viewModel.forecasts {
                    List(forecasts) {
                        forecast in
                        ForecastRow(forecast: forecast)
                    } .listStyle(.plain)
                      .navigationTitle("일기예보")
                      .navigationBarTitleDisplayMode(.inline)

                } else {
                    EmptyView()
                }
            }
        }


             
    }
}


#Preview {

    ForecastView(city: "seoul").environmentObject(ForecastViewModel())
}
