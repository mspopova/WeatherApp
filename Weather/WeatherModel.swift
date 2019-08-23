//
//  WeatherModel.swift
//  Weather
//
//  Created by Марина Попова on 22/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import Foundation


struct CurrentLocalWeather: Codable {
    let clouds: Clouds
    let cod: Int
    let coord: Coord
    //let dt: Int
    //let id: Int
    let main: Main
    let name: String //city name
    let sys: Sys
    //let visibility: Int
    let weather: [Weather]
    //let wind: Wind
    
    init() {
        //base = ""
        clouds = Clouds()
        cod = 0
        coord = Coord()
        //dt = 0
        //id = 0
        main = Main()
        name = ""
        sys = Sys ()
        //visibility = 0
        weather = []
        //wind  = Wind()
    }
}
struct Clouds: Codable {
    let all: Int
    
    init() {
        all = 0
    }
}
struct Coord: Codable {
    let lat: Double
    let lon: Double
    
    init() {
        lat = 0
        lon = 0
    }
}
struct Main: Codable {
    let humidity: Double
    let pressure: Double
    let temp: Double
    let tempMax: Double
    let tempMin: Double
    //let seaLevel: Double
    //let grndLevel: Double
    private enum CodingKeys: String, CodingKey {
        case humidity, pressure, temp, tempMax = "temp_max", tempMin = "temp_min"
    }
    init() {
        humidity = 0
        pressure = 0
        temp = 0
        tempMax = 0
        tempMin = 0
        //seaLevel = 0
        //grndLevel = 0
    }
}
struct Sys: Codable {
    let country: String
    //let id: Int
    let message: Double
    let sunrise: UInt64
    let sunset: UInt64
    //let type: Int
    
    init(){
        country = ""
        //id = 0
        message = 0
        sunrise = 0
        sunset = 0
        //type = 0
    }
}
struct Weather: Codable {
    let description: String
    let icon: String
    let id: Int
    let main: String
    init(){
        description = ""
        icon = ""
        id = 0
        main = ""
    }
}



class WeatherModel {
    
    static func weatherDecoder(weatherData: Data) -> CurrentLocalWeather {
        let decoder = JSONDecoder()

        do {
            let currentLocalWeather = try decoder.decode(CurrentLocalWeather.self, from: weatherData)
            return currentLocalWeather
        } catch {
            print(error)
            return CurrentLocalWeather()
        }
    }
    
    public static func weatherConditionSymbol(fromWeathercode: Int) -> String {
        switch fromWeathercode {
        case let x where (x >= 200 && x <= 202) || (x >= 230 && x <= 232):
            return "⛈"
        case let x where x >= 210 && x <= 211:
            return "🌩"
        case let x where x >= 212 && x <= 221:
            return "⚡️"
        case let x where x >= 300 && x <= 321:
            return "🌦"
        case let x where x >= 500 && x <= 531:
            return "🌧"
        case let x where x >= 600 && x <= 602:
            return "☃️"
        case let x where x >= 603 && x <= 622:
            return "🌨"
        case let x where x >= 701 && x <= 771:
            return "🌫"
        case let x where x == 781 || x == 900:
            return "🌪"
        case let x where x == 800:
            return "☀️"
        case let x where x == 801:
            return "🌤"
        case let x where x == 802:
            return "⛅️"
        case let x where x == 803:
            return "🌥"
        case let x where x == 804:
            return "☁️"
        case let x where x >= 952 && x <= 956 || x == 905:
            return "🌬"
        case let x where x >= 957 && x <= 961 || x == 771:
            return "💨"
        case let x where x == 901 || x == 902 || x == 962:
            return "🌀"
        case let x where x == 903:
            return "❄️"
        case let x where x == 904:
            return "🌡"
        case let x where x == 962:
            return "🌋"
        default:
            return "❓"
        }
    }
}


