//
//  Weather.swift
//  Typeweather
//
//  Created by Jure Žove on 14. 09. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

import Foundation
import CoreData

class Weather: NSManagedObject {

    @NSManaged var condition: String
    @NSManaged var conditionDescription: String
    @NSManaged var date: NSDate
    @NSManaged var humidity: NSDecimalNumber
    @NSManaged var locationName: String
    @NSManaged var sunrise: NSDate
    @NSManaged var sunset: NSDate
    @NSManaged var temperature: NSDecimalNumber
    @NSManaged var tempHigh: NSDecimalNumber
    @NSManaged var tempLow: NSDecimalNumber
    @NSManaged var windBearing: NSDecimalNumber
    @NSManaged var windSpeed: NSDecimalNumber

}
