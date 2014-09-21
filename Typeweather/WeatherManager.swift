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
    
    func testAlamofire() {
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    
    func currentWeatherFor(city: String, closure:(json: AnyObject)->()) {
        self.currengWeatherFor(["units": measurementUnit(), "q": city], closure:closure)
    }
    
    func currentWeatherFor(coordinate: CLLocationCoordinate2D, closure:(json: AnyObject)->()) {
        self.currengWeatherFor(["units": measurementUnit(), "lat": coordinate.latitude, "lon": coordinate.longitude], closure:closure)
    }
    
    func yesterdaysWeatherForCity(city:String, closure:(json: AnyObject)->()) {
        self.yesterdaysWeatherForCity(["q" : city], closure: closure)
    }
    
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
    
    private func currengWeatherFor(params: Dictionary<String, AnyObject>, closure:(json: AnyObject)->()) {
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
        yesterdayComponents1.setValue(+HoursDifference, forComponent: NSCalendarUnit.CalendarUnitDay);
        
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
//                println(request)
//                println(JSON)
                closure(json: JSON!)
        }
    }
}
