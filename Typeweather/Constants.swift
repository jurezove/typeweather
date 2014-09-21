//
//  Constants.swift
//  Typeweather
//
//  Created by Jure Žove on 19. 09. 14.
//  Copyright (c) 2014 Jure Zove. All rights reserved.
//

import Foundation
import UIKit

let fontSize:CGFloat = 18.0
let kUpdatedLocationTimeKey:String = "kUpdatedLocationTimeKey"

class Constants {

    class func mainFont() -> UIFont {
        return UIFont(name:"Cardo-Regular", size:fontSize)
    }
    
    class func boldFont() -> UIFont {
        return UIFont(name:"Cardo-Bold", size:fontSize)
    }
    
    class func italicFont() -> UIFont {
        return UIFont(name:"Cardo-Italic", size:fontSize)
    }
}