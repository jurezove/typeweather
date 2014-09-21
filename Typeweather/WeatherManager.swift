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
    
    func testAlamofire() {
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
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
    
    func getYesterdaysAverageTemperature(city: String, closure:(average: Double)->()) {
        self.yesterdaysWeatherForCity(city, closure: { (json) -> () in
            println(json)
            var list:[AnyObject] = json["list"] as Array
            var sum:Double = 0
            var count:Double = 0
            for object in list {
                let dict:[String:AnyObject] = object as Dictionary
                if let weather:Weather = self.parseWeather(object as Dictionary) {
                    sum += weather.main["temp"] as Double
                    count++
//                    if (WeatherManager.usingMetric()) {
//                        let celsius = WeatherManager.convertToCelsius(weather.main["temp"] as Double)
//                        println("Celsius: \(celsius)°C")
//                    } else {
//                        let celsius = WeatherManager.convertToFahrenheit(weather.main["temp"] as Double)
//                        println("Fahrenheit: \(celsius)°F")
//                    }
                }
            }
            let average = sum/count
            closure(average: average)
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
    
}
