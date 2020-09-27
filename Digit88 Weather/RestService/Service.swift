//
//  Service.swift
//  Digit88 Weather
//
//  Created by Kiran, Ravi | RIEPL on 27/09/20.
//  Copyright © 2020 Kiran, Ravi | RIEPL. All rights reserved.
//

import UIKit

enum EndPoints: String {
    case weatherAPI = "https://api.openweathermap.org/data/2.5/"
    case searchImage = "https://pixabay.com/api/"
}

struct Service {
    static let shared = Service()
    private init() {}
    
    func getWeather(city: String,completionHander:@escaping ([String: Any]?, Error?) -> Void) {
        let actualCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = String(format: "%@weather?q=%@&appid=%@&units=%@",EndPoints.weatherAPI.rawValue ,actualCity!, "10f0f7dcbf350d7fdb2a52ed2fb976ba","metric")
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                var jsonResult:  [String: Any]?
                var err: Error?
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    
                } catch {
                    err = error
                }
                completionHander(jsonResult, err)
            }
            task.resume()
        }
    }
    
    func getWeatherTrends(city: String,completionHander:@escaping ([String: Any]?, Error?) -> Void) {
        let actualCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = String(format: "%@forecast?q=%@&appid=%@&units=%@",EndPoints.weatherAPI.rawValue ,actualCity!, "10f0f7dcbf350d7fdb2a52ed2fb976ba","metric")
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                var jsonResult:  [String: Any]?
                var err: Error?
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    
                } catch {
                    err = error
                }
                completionHander(jsonResult, err)
            }
            task.resume()
        }
    }
    
    func searchImage(city: String,completionHander: @escaping ([String: Any]?, Error?) -> Void) {
        let actualCity = "\(city) city".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var err: Error?
        let urlString = String(format: "%@?key=%@&q=&image_type=photo&pretty=true&category=places", EndPoints.searchImage.rawValue,"18469293-1e9a51e42d329a435cbcaddaa",actualCity!)
        if let url = URL(string: urlString) {
            var jsonResult: [String: Any]?
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    
                } catch {
                    err = error
                }
                completionHander(jsonResult, err)
            }
            task.resume()
        }
        
    }
}
