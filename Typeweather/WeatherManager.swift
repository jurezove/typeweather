//
//  WeatherManager.swift
//  Typeweather
//
//  Created by Jure Žove on 14. 09. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

import Foundation
import Alamofire

class WeatherManager {
    let HoursDifference = 2
    let OpenWeatherAPIKey = "cf98fc035983402806b546354723dcf8"
    let BaseURL = "http://api.openweathermap.org/data/2.5/"
    
    func testAlamofire() {
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    
    func currentWeatherFor(city:String) {
        Alamofire.request(.GET, BaseURL.stringByAppendingPathComponent("weather"), parameters: ["q" : city, "APPID" : OpenWeatherAPIKey])
            .responseJSON {(request, response, JSON, error) in
                println(JSON)
        }
    }
    
    func yesterdaysWeatherForCity(city:String) {
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
        
        Alamofire.request(.GET, BaseURL.stringByAppendingPathComponent("history/city"),
            parameters: ["q" : city, "APPID" : OpenWeatherAPIKey, "start" : startUTC, "end": endUTC])
            .responseJSON {(request, response, JSON, error) in
                println(request)
                println(JSON)
        }
    }
}
