//
//  ForecastViewModel.swift
//  ABoHa
//
//  Created by wizard on 11/26/24.
//
import SwiftUI
import CoreLocation
import Alamofire

class ForecastViewModel:NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var forecasts:[Forecast]?
    @Published var weather:Result?
    @Published var location:CLLocationCoordinate2D?
    let appid = "eac371f20fe46445aa753c43bc4e45b8"
    let host = "https://api.openweathermap.org/data/2.5"
    private var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.location = newLocation.coordinate
            manager.stopUpdatingLocation()
            self.getWeather(location: newLocation.coordinate)
            self.getForecast(location: newLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func getWeather(location:CLLocationCoordinate2D) {
        let endPoint = "\(host)/weather"
        let params:Parameters = ["lon":location.longitude, "lat":location.latitude, "appid":appid, "units":"metric", "lang":"kr"]
        AF.request(endPoint, method: .get, parameters: params)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Result.self) { response in
                switch response.result {
                    case .success(let result):
                        self.weather = result
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
    }
    
    func getForecast(city:String){
        let endPoint = "\(host)/forecast"
        let params: Parameters = ["q":city, "appid":appid, "units":"metric", "lang":"kr"]
        AF.request(endPoint, method: .get, parameters: params)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Root.self) { response in
                switch response.result {
                    case .success(let forecasts):
                        self.forecasts = forecasts.list
                        print(forecasts.list[0])
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
    }
    
    func getForecast(location:CLLocationCoordinate2D){
        let endPoint = "\(host)/forecast"
        let params: Parameters = ["lon":location.longitude , "lat":location.latitude, "appid":appid, "units":"metric", "lang":"kr"]
        AF.request(endPoint, method: .get, parameters: params)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Root.self) { response in
                switch response.result {
                    case .success(let forecasts):
                        self.forecasts = forecasts.list
                        print(forecasts.list[0])
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
    }
    
    
}
