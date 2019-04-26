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
    //rgb(235, 47, 6)
    static var flatDarkRed: NSColor {
        return NSColor(red: 235/255, green: 47/255, blue: 47/255, alpha: 1.0)
    }
    
    //rgb(76, 209, 55)
    static var flatGreen: NSColor{
      return NSColor(red: 76/255, green: 209/255, blue: 55/255, alpha: 1.0)
    }
    
    //rgb(139,0,139)
    static var flatMagenta: NSColor {
        return NSColor(red: 145/255, green: 26/255, blue: 48/255, alpha: 1.0)
    }
    
    //rgb(240, 147, 43)
    static var flatOrange: NSColor {
        return NSColor(red: 240/255, green: 147/255, blue: 43/255, alpha: 1.0)
    }
    
    //rgb(142,36,170)
    static var flatPurple: NSColor {
        return NSColor(red: 142/255, green: 36/255, blue: 170/255, alpha: 1.0)
    }
    
    //rgb(251, 197, 49)
    static var flatYellow: NSColor {
        return NSColor(red: 251/255, green: 197/255, blue: 49/255, alpha: 1.0)
    }
}
