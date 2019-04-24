//
//  PollutionLevel.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/24/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Cocoa

enum PollutionLevel {
    case good
    case moderate
    case sensitiveGroups
    case unhealthy
    case veryUnhealthy
    case hazardous
    
    init(value: Int) {
        switch value {
        case let value where value > 300:
            self = .hazardous
        case let value where value > 200:
            self = .veryUnhealthy
        case let value where value > 150:
            self = .unhealthy
        case let value where value > 100:
            self = .sensitiveGroups
        case let value where value > 50:
            self = .moderate
        default:
            self = .good
        }
    }
    
    var color: NSColor {
        switch self {
        case .good:
            return .flatGreen
        case .moderate:
            return .flatYellow
        case .sensitiveGroups:
            return .flatOrange
        case .unhealthy:
            return .flatDarkRed
        case .veryUnhealthy:
            return .flatPurple
        case .hazardous:
            return .flatMagenta
        }
    }
    
    var localizedName: String {
        switch self {
        case .good:
            return NSLocalizedString("Good", comment: "")
        case .moderate:
            return NSLocalizedString("Moderate", comment: "")
        case .sensitiveGroups:
            return NSLocalizedString("SensitiveGroups", comment: "")
        case .unhealthy:
            return NSLocalizedString("Unhealthy", comment: "")
        case .veryUnhealthy:
            return NSLocalizedString("VeryUnhealthy", comment: "")
        case .hazardous:
            return NSLocalizedString("Hazardous", comment: "")
        }
    }
}
