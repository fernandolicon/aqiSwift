//
//  StyleGuide.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/24/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Cocoa

extension NSColor {
    //rgb(192, 57, 43)
    static var flatDarkRed: NSColor {
        return NSColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1.0)
    }
    
    //rgb(46, 204, 113)
    static var flatGreen: NSColor{
      return NSColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    }
    
    //rgb(183,28,28)
    static var flatMagenta: NSColor {
        return NSColor(red: 183/255, green: 28/255, blue: 28/255, alpha: 1.0)
    }
    
    //rgb(243, 156, 18)
    static var flatOrange: NSColor {
        return NSColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
    }
    
    //rgb(142,36,170)
    static var flatPurple: NSColor {
        return NSColor(red: 142/255, green: 36/255, blue: 170/255, alpha: 1.0)
    }
    
    //rgb(241, 196, 15)
    static var flatYellow: NSColor {
        return NSColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)
    }
}
