//
//  Persistance.swift
//  Digit88 Weather
//
//  Created by Kiran, Ravi | RIEPL on 27/09/20.
//  Copyright © 2020 Kiran, Ravi | RIEPL. All rights reserved.
//

import UIKit

struct Persistance {
    static let shared = Persistance()
    private init(){}
    func setCity(city: String) {
        UserDefaults.standard.set(city, forKey: "cityName")
        
    }
    func getCity() -> String? {
        return UserDefaults.standard.string(forKey: "cityName")
    }
}
