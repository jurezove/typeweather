//
//  Consieur.swift
//  Typeweather
//
//  Created by Jure Žove on 19. 09. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

import Foundation

let rainArray =
    [NSLocalizedString("Unfortunately it will be raining, so you better take your umbrella.", comment: ""),
    NSLocalizedString("Some rain is also to be expected. Don't forget the umbrella.", comment: ""),]

let snowArray =
    [NSLocalizedString("It also looks like it's going to snow today.", comment: ""),
    NSLocalizedString("You might be happy or you might be sad but snow is forecasted.", comment: ""),]

class Consieur {

    class func rainText() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(rainArray.count)))
        return rainArray[randomIndex]
    }
    
    class func snowText() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(snowArray.count)))
        return snowArray[randomIndex]
    }
    
    class func mainText(difference: Double, rain: Bool, snow: Bool) -> String {
        var weather:String = ""
        if (difference >= 10) {
            weather = NSLocalizedString("a lot hotter compared to yesterday", comment: "")
        } else if (difference < 10 && difference >= 5) {
            weather = NSLocalizedString("quite warmer than yesterday", comment: "")
        } else if (difference < 5 && difference > 0) {
            weather = NSLocalizedString("a bit warmer than yesterday", comment: "")
        } else if (difference == 0) {
            weather = NSLocalizedString("the same as yesterday", comment: "")
        } else if (difference < 0 && difference > -5) {
            weather = NSLocalizedString("a bit colder than yesterday", comment: "")
        } else if (difference <= -5 && difference > -10) {
            weather = NSLocalizedString("quite colder compared to yesterday", comment: "")
        } else if (difference <= -10) {
            weather = NSLocalizedString("a lot colder than yesterday", comment: "")
        } else {
            weather = NSLocalizedString("the same as yesterday", comment: "")
        }
        var additional:String = ""
        if (rain) {
            additional = rainText();
        } else if (snow) {
            additional = snowText();
        }
        return String(format: "The weather today will be %@.%@", weather, " \(additional)")
    }
    
    class func boldText(difference: Double) -> String {
        if (difference >= 10) {
            return NSLocalizedString("a lot hotter", comment: "")
        } else if (difference < 10 && difference >= 5) {
            return NSLocalizedString("warmer", comment: "")
        } else if (difference < 5 && difference > 0) {
            return NSLocalizedString("a bit warmer", comment: "")
        } else if (difference == 0) {
            return NSLocalizedString("the same", comment: "")
        } else if (difference < 0 && difference > -5) {
            return NSLocalizedString("a bit colder", comment: "")
        } else if (difference <= -5 && difference > -10) {
            return NSLocalizedString("colder", comment: "")
        } else if (difference <= -10) {
            return NSLocalizedString("a lot colder", comment: "")
        }
        return ""
    }
}