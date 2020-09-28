//
//  WeatherViewModel.swift
//  Digit88 Weather
//
//  Created by Kiran, Ravi | RIEPL on 27/09/20.
//  Copyright © 2020 Kiran, Ravi | RIEPL. All rights reserved.
//

import UIKit

protocol WeatherDelegate {
    func weatherResponse(weather: Weather, error: Error?)
    func cityImage(imageUrl: URL?, error: Error?)
    func weatherTrends(data: [Double:Int], error: Error?)
}

struct WeatherViewModel {
    var weatherDelegate: WeatherDelegate?
    var averageWeather = 18
    var minTemperature = -5
    var maxTemperature = 42
    
    init(weatherDelegate: WeatherDelegate) {
        self.weatherDelegate = weatherDelegate
        if let city = Persistance.shared.getCity() {
            self.fetchWeather(city: city)
        }
    }
    
    func fetchWeather(city: String) {
        
        Service.shared.getWeather(city: city) { (json, err) in
            
            var temperature = ""
            var humidity = ""
            var description = ""
            var info = ""
            if let mainTemp = json?["main"] as? [String: Any], let temp = mainTemp["temp"], let feels = mainTemp["feels_like"], let humi = mainTemp["humidity"] {
                temperature = "\(temp)"
                humidity = "\(humi)"
                info = "\(feels)"
            }
            if let weatherObj = json?["weather"] as? [[String: Any]], let descrip = weatherObj[0]["description"] as? String {
                description = descrip
            }
            Persistance.shared.setCity(city: city)
            self.weatherDelegate?.weatherResponse(weather: Weather(temperature: temperature, humidity: humidity, description: description, info: info, city: city), error: err)
            self.fetchCityImage(searchCity: city)
        }
    }
    
    func fetchCityImage(searchCity: String?) {
        guard let city = searchCity else {
            return
        }
        var imgURL: URL?
        Service.shared.searchImage(city: city) { (json, err) in
            if let hits = json?["hits"] as? [[String: Any]] {
                let index = Int.random(in: 0..<hits.count)
                if hits.count > 0, let imageURL = hits[index]["largeImageURL"] as? String {
                    if let url = URL(string: imageURL) {
                        imgURL = url
                    }
                }
            }
            self.weatherDelegate?.cityImage(imageUrl: imgURL, error: err)
        }
    }
    
    func fetchWeatherTrends(city: String) {
        
        Service.shared.getWeatherTrends(city: city) { (json, err) in
            var trends = [Double: Int]()
            if let weatherArray = json?["list"] as? [[String: Any]] {
                
                for weatherJson in weatherArray {
                    if let mainTemp = weatherJson["main"] as? [String: Any], let temp = mainTemp["temp"] as? NSNumber, let date = weatherJson["dt"] as? Double  {
                        
                        let day = NSDate(timeIntervalSince1970: date)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = DateFormatter.Style.none
                        dateFormatter.dateStyle = DateFormatter.Style.short
                        
                        let daySplit = dateFormatter.string(from: day as Date).split(separator: "/")
                        let actualDay = Double(daySplit[1])
                        trends[actualDay!] = Int(truncating: temp)
                        
                    }
                }
            }
            self.weatherDelegate?.weatherTrends(data: trends, error: err)
        }
    }
}

