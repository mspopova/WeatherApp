//
//  PointWeather.swift
//  Weather
//
//  Created by Марина Попова on 23/08/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import Foundation
import MapKit

class PointWeather {
    private var coord: CLLocationCoordinate2D
    private var city: String
    private var temp: Double
    private var state: String
    private var isLoaded: Bool
    
    private let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "49a3d1206da2f70237be1baf20fa17d1"
    
    init(new_coord: CLLocationCoordinate2D){
        coord = new_coord
        city = "none"
        temp = 0
        state = ""
        isLoaded = false
    }
    
    func setWeather(){
        
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(self.coord.latitude)&lon=\(self.coord.longitude)")!
        let request = URLRequest(url: weatherRequestURL)
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
                return
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                // print("Data:\n\(data!)")
                guard let data = data else {
                    return
                }
                
                print("Raw data:\n\(data)\n")
                
                
                do {
                    let json = try JSONDecoder().decode(CurrentLocalWeather.self, from: data)
                    self.city = json.name
                    self.temp = json.main.temp-273
                    //self.state = json.weather[0].main
                    self.state = WeatherModel.weatherConditionSymbol(fromWeathercode: json.weather[0].id)
                    self.isLoaded = true
                } catch {
                    print("can't parce")
                }
                
            }
            
        }).resume()
    }
    func printWeather(){
        print(coord,city,temp,state)
    }
    
    func getCity() -> String{
        return city
    }
    
    func getTemp() -> Double{
        return temp
    }

    func getState() -> String{
        return state
    }
    
    func getCoord() -> CLLocationCoordinate2D{
        return coord
    }
    
    
}
