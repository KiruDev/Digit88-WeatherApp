//
//  CitySearchViewModel.swift
//  Digit88 Weather
//
//  Created by Kiran, Ravi | RIEPL on 27/09/20.
//  Copyright © 2020 Kiran, Ravi | RIEPL. All rights reserved.
//

import UIKit

protocol CityFetcherDelegate: class {
    func fetcherResponse(cities: [String], error: Error?);
}

struct CitySearchViewModel {
    
   weak var cityFetcher: CityFetcherDelegate!
    
    public func fetchCities() {
        var err: Error? = nil
        var cities = [String]()
        
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let json = jsonResult as? Array<[String: Any]> {
                    for place: [String: Any] in json  {
                        if let city = place["city"] as? String {
                            cities.append(city)
                        }
                    }
                }
            } catch {
                err = error
            }
        }
        cityFetcher.fetcherResponse(cities: cities, error: err)
    }
}
