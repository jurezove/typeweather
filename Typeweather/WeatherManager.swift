//
//  WeatherManager.swift
//  Typeweather
//
//  Created by Jure Žove on 14. 09. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

class WeatherManager {
    let HoursDifference = 2
    let OpenWeatherAPIKey:String = "cf98fc035983402806b546354723dcf8"
    let BaseURL = "http://api.openweathermap.org/data/2.5/"
    
    struct Weather {
        let clouds: NSDictionary
        let dt: NSString
        let main: NSDictionary
        let weather: NSArray
        let rain: NSDictionary
        let snow: NSDictionary
    }
    
    func currentWeatherFor(city: String, closure:(json: AnyObject)->()) {
        self.currentWeatherFor(["units": measurementUnit(), "q": city], closure:closure)
    }
    
    func currentWeatherFor(coordinate: CLLocationCoordinate2D, closure:(json: AnyObject)->()) {
        self.currentWeatherFor(["units": measurementUnit(), "lat": coordinate.latitude, "lon": coordinate.longitude], closure:closure)
    }
    
    func yesterdaysWeatherForCity(city:String, closure:(json: AnyObject)->()) {
        self.yesterdaysWeatherForCity(["q" : city], closure: closure)
    }
    
    func yesterdaysAverageTemperatureForCityID(cityID: Int64, closure:(average: Double)->()) {
        self.yesterdaysAverageTemp(["id": "\(cityID)"], closure: { (average) -> () in
            closure(average: average)
        })
    }
    
    func yesterdaysAverageTemperature(city: String, closure:(average: Double)->()) {
        self.yesterdaysAverageTemp(["q": city], closure: { (average) -> () in
            closure(average: average)
        })
    }
    
    func weatherDifferenceForCoordinates(coordinate: CLLocationCoordinate2D, closure:(difference: WeatherDifference)->()) {
        self.weatherDifferenceFor(["lat": coordinate.latitude, "lon": coordinate.longitude], closure: { (difference) -> () in
            closure(difference: difference)
        })
    }
    
    func weatherDifferenceFor(city: String, closure:(difference: WeatherDifference)->()) {
        self.weatherDifferenceFor(["q": city], closure: { (difference) -> () in
            closure(difference: difference)
        })
    }
    
    // Class functions
    
    class func convertToCelsius(kelvin: Double) -> Double {
         return kelvin - 273.15
    }
    
    class func convertToFahrenheit(kelvin: Double) -> Double {
        return 1.8 * (kelvin - 273.15) + 32
    }
    
    class func usingMetric() -> Bool {
       return NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as Bool
    }
    
    // Privates
    
    private func measurementUnit() -> String {
        if NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as Bool {
            return "metric"
        } else {
            return "imperial"
        }
    }
    
    private func saveUpdatedTime() {
        NSUserDefaults.standardUserDefaults().setValue(NSDate.date(), forKey: kUpdatedLocationTimeKey)
    }
    
    private func currentWeatherFor(params: Dictionary<String, AnyObject>, closure:(json: AnyObject)->()) {
        var modified:Dictionary<String, AnyObject> = params
        modified["APPID"] = OpenWeatherAPIKey
        Alamofire.request(.GET, BaseURL.stringByAppendingPathComponent("weather"), parameters: modified)
            .responseJSON {(request, response, JSON, error) in
                closure(json: JSON!)
                self.saveUpdatedTime()
        }
    }
    
    private func yesterdaysWeatherForCity(params: [String: AnyObject], closure:(json: AnyObject)->()) {
        var modified:Dictionary<String, AnyObject> = params
        modified["APPID"] = OpenWeatherAPIKey
        
        var yesterdayComponents1 = NSDateComponents()
        yesterdayComponents1.setValue(-1, forComponent: NSCalendarUnit.CalendarUnitDay);
        yesterdayComponents1.setValue(+HoursDifference, forComponent: NSCalendarUnit.CalendarUnitHour);
        
        var yesterdayComponents2 = NSDateComponents()
        yesterdayComponents2.setValue(-1, forComponent: NSCalendarUnit.CalendarUnitDay);
        yesterdayComponents2.setValue(-HoursDifference, forComponent: NSCalendarUnit.CalendarUnitHour);
        
        let date: NSDate = NSDate()
        var end = NSCalendar.currentCalendar().dateByAddingComponents(yesterdayComponents1, toDate: date, options: NSCalendarOptions(0))
        var start = NSCalendar.currentCalendar().dateByAddingComponents(yesterdayComponents2, toDate: date, options: NSCalendarOptions(0))
        var startUTC = round(start!.timeIntervalSince1970)
        var endUTC = round(end!.timeIntervalSince1970)
        
        modified["start"] = startUTC
        modified["end"] = endUTC
        
        Alamofire.request(.GET, BaseURL.stringByAppendingPathComponent("history/city"),
            parameters: modified)
            .responseJSON {(request, response, JSON, error) in
                closure(json: JSON!)
        }
    }
    
    private func parseWeather(dict: [ String : AnyObject ]) -> Weather? {
        if let main = dict["main"] as? NSDictionary {
            if let weather = dict["weather"] as? NSArray {
                return Weather(clouds: [:], dt: "", main: main, weather: weather, rain: [:], snow: [:])
            }
        }
        return nil
    }
    
    private func yesterdaysAverageTemp(params: [String:AnyObject], closure:(average: Double)->()) {
        yesterdaysWeatherForCity(params, closure: { (json) -> () in
            var list:[AnyObject] = json["list"] as Array
            var average:Double
            if (list.count > 0) {
                average = (list as AnyObject).valueForKeyPath("@avg.main.temp") as Double
            }
            average = 0
            closure(average: average)
        })
    }
    
    private func weatherDifferenceFor(params: [String:AnyObject], closure:(difference: WeatherDifference)->()) {
        self.currentWeatherFor(params, closure: { (json) -> () in
            // Get yesterdays average temp
            if let first = json as? [String: AnyObject] {
                let cityID:Int64 = (first["id"] as? NSNumber)!.longLongValue
                let main = first["main"]! as Dictionary<String, AnyObject>
                let tempKelvin = main["temp"]! as Double
                var rain = false
                var snow = false
                if let hasSnow: AnyObject = first["snow"]? {
                    snow = true
                }
                if let hasRain: AnyObject = first["rain"]? {
                    rain = true
                }
                
                self.yesterdaysAverageTemperatureForCityID(cityID, closure: { (average) -> () in
//                    println(average)
                    let weatherDifference = WeatherDifference(yesterday: average, today: tempKelvin, chanceOfRain: rain, chanceOfSnow: snow)
                    closure(difference: weatherDifference)
                })
            }
        })
    }
    
}
