//
//  Prettyfier.swift
//  Typeweather
//
//  Created by Jure Žove on 19. 09. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

import Foundation
import UIKit

class Prettyfier {
    class func boldify(string: NSString, words: NSArray) -> NSAttributedString {
        let attributes = [NSFontAttributeName : Constants.boldFont()]
        return self.manipulate(string, words: words, attributes: attributes)
    }
    
    class func manipulate(string: NSString, words: NSArray, attributes: NSDictionary) -> NSMutableAttributedString {
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: string)
        for word in words as [NSString] {
            let range:NSRange = string.rangeOfString(word)
            attributedString.setAttributes(attributes, range: range)
            
        }
        return attributedString
    }
    
    class func temperatureText(temp: Double) -> String {
        return String(format: "%.0f°F", temp)
    }
}