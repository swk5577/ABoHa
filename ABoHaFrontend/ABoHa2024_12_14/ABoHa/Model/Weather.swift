//
//  Weather.swift
//  ABoHa
//
//  Created by 이미진 on 11/19/24.
//


import Foundation

//https://openweathermap.org/current
struct Weather:Codable {
    let main:String
    let description:String
    let icon:String
}

struct Coord:Codable {
    let lon:Double
    let lat:Double
}

struct Main:Codable {
    let temp: Double
    let humidity: Int
}

struct Result:Codable {
    let weather:[Weather]
    let main: Main
    let name: String
}

//https://openweathermap.org/forecast5
struct Forecast: Codable, Identifiable {
    let id: Int
    let main: Main
    let weather: [Weather]
    let date: String

//    let city: [City]
    enum CodingKeys: String, CodingKey {
        case id = "dt"
        case main
        case weather
        case date = "dt_txt"

    }
}

struct Root: Codable {
    let list:[Forecast]
}



