//
//  WeatherDifference.swift
//  Typeweather
//
//  Created by Jure Žove on 22. 09. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

import Foundation

class WeatherDifference {
    var differenceInCelsius:Double
    var differenceInFahrenheit:Double
    var chanceOfRain:Bool
    var chanceOfSnow:Bool
    
    init(differenceInCelsius:Double, differenceInFahrenheit:Double, chanceOfRain:Bool, chanceOfSnow:Bool) {
        self.differenceInCelsius = differenceInCelsius
        self.differenceInFahrenheit = differenceInFahrenheit
        self.chanceOfRain = chanceOfRain
        self.chanceOfSnow = chanceOfSnow
    }
    
    init(yesterday:Double, today:Double, chanceOfRain:Bool, chanceOfSnow:Bool) {
        self.differenceInCelsius = WeatherManager.convertToCelsius(today) - WeatherManager.convertToCelsius(yesterday)
        self.differenceInFahrenheit = WeatherManager.convertToFahrenheit(today) - WeatherManager.convertToFahrenheit(yesterday)
        self.chanceOfRain = chanceOfRain
        self.chanceOfSnow = chanceOfSnow
    }
}