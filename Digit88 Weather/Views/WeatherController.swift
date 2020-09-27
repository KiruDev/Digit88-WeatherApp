//
//  ViewController.swift
//  Digit88 Weather
//
//  Created by Kiran, Ravi | RIEPL on 26/09/20.
//  Copyright © 2020 Kiran, Ravi | RIEPL. All rights reserved.
//

import UIKit
import SwiftChart

/**
 View for weather and weather search
 */
class WeatherController: UIViewController, CityFetcherDelegate, WeatherDelegate {
    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityInputField: AutoCompleteField?
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    @IBOutlet weak var infoText: UILabel!
    
    // City input view model
    var citySearchViewModel: CitySearchViewModel?
    
    //weather and weather trends view model
    var weatherViewModel: WeatherViewModel?
    @IBOutlet weak var weatherChart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        citySearchViewModel = CitySearchViewModel(cityFetcher: self)
        citySearchViewModel?.fetchCities()
        weatherViewModel = WeatherViewModel(weatherDelegate: self)
        
        cityInputField?.itemSelectionHandler = {item, itemPosition in
            guard let city = self.cityInputField?.text else {
                return
            }
            self.weatherViewModel?.fetchWeather(city: city)
        }
    }
    
    func cityImage(imageUrl: URL?, error: Error?) {
        guard error == nil else {
            return
        }
        if let url = imageUrl {
            // Load background Image
            DispatchQueue.main.async { [weak self] in
                self?.cityImage.load(url: url)
            }
        }
    }
    
    func weatherResponse(weather: Weather, error: Error?) {
        guard error == nil else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.cityInputField?.text = weather.city
            self?.temperature.text = "\(weather.temperature)°C"
            self?.infoText.text = "Feels Like \(weather.info)°C and Humidity is \(weather.humidity)"
            self?.weatherText.text = "\(weather.description)"
            self?.weatherViewModel?.fetchWeatherTrends(city: weather.city)
            self?.cityInputField?.bringSubviewToFront((self?.view!)!)
        }
    }
    
    func fetcherResponse(cities: [String], error: Error?) {
        guard error == nil else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.cityInputField?.filterStrings(cities)
        }
    }
    
    // plotting chart
    func weatherTrends(data: [Double : Int], error: Error?) {
        DispatchQueue.main.async { [weak self] in
            var chartData =  [Double]()
            
            for day:Double in data.keys {
                if let dayTemp = data[day] {
                    chartData.append(Double(dayTemp))
                }
            }
            let series = ChartSeries(chartData)
            series.area = true
            self?.weatherChart.removeAllSeries()
            self?.weatherChart.add(series)
            
            series.colors = (
                above: ChartColors.cyanColor(),
                below: ChartColors.orangeColor(),
                zeroLevel: 18
            )
            self?.weatherChart.minY = -5
            self?.weatherChart.maxY = 42
            self?.weatherChart.minX = data.keys.first
            self?.weatherChart.yLabelsFormatter = { String(Int($1)) +  "ºC"}
            
            self?.weatherChart.backgroundColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 100.0/255.0, alpha: 1.0)
            
            self?.weatherChart.add(series)
        }
    }
}
