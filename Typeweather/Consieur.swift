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
}