//
//  UIColor.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 6/21/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

extension UIColor {
    class func navBgColor() -> UIColor {
        return UIColor(red: 72.0/255.0, green: 0.0/255.0, blue: 112.0/255.0, alpha: 1)
    }
    class func navHighlightColor() -> UIColor {
        return UIColor(red: 9.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1)
    }
    class func tableBgColor() -> UIColor {
        return white //UIColor(red: 128.0/255.0, green: 19.0/255.0, blue: 188.0/255.0, alpha: 1)
    }
    class func navTextColor() -> UIColor {
        return white //UIColor(red: 221.0/255.0, green: 191.0/255.0, blue: 19.0/255.0, alpha: 1)
    }
    class func cardViewBgColor() -> UIColor {
        return teal()
    }
    class func cardViewTextColor() -> UIColor {
        return lightBlue()
    }
    class func buttonBgColor() -> UIColor {
        return navBgColor()
    }
    class func buttonTextColor() -> UIColor {
        return navHighlightColor()
    }
    class func burgundy() -> UIColor {
        return UIColor(red: 112.0/255.0, green: 11.0/255.0, blue: 77.0/255.0, alpha: 1)
    }
    class func lightBurgundy() -> UIColor {
        return UIColor(red: 239.0/255.0, green: 96.0/255.0, blue: 190.0/255.0, alpha: 1)
    }
    class func lightBlue() -> UIColor {
        return UIColor(red: 12.0/255.0, green: 230.0/255.0, blue: 239.0/255.0, alpha: 1)
    }
    class func teal() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 107.0/255.0, blue: 112.0/255.0, alpha: 1)
    }
    class func yellowTan() -> UIColor {
        return UIColor(red: 176.0/255.0, green: 155.0/255.0, blue: 35.0/255.0, alpha: 1)
    }
}
