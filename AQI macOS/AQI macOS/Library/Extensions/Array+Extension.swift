//
//  Array+Extension.swift
//  AQI macOS
//
//  Created by Fernando Mata on 5/21/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation

typealias ArrayOrderedUpdates<T: Equatable> = (added: [T], removed: [T])
typealias ArrayNonOrderedUpdates<T: Hashable> = (added: [T], removed: [T])

extension Array where Element: Equatable {
    /// Returns values added and removed from arrays with the original order.
    static func diffArraysOrdered(lhs: [Element], rhs: [Element]) -> ArrayOrderedUpdates<Element> {
        let leftMutable = NSMutableArray(array: lhs)
        let rightMutable = NSMutableArray(array: rhs)
        leftMutable.removeObjects(in: rhs)
        rightMutable.removeObjects(in: lhs)
        let added = rightMutable as! Array<Element>
        let removed = leftMutable as! Array<Element>
        
        return ArrayOrderedUpdates(added, removed)
    }
}

extension Array where Element: Hashable {
    /// Returns values added and removed from arrays. Faster solution that returns a non-ordered array
    static func diffArrays(lhs: [Element], rhs: [Element]) -> ArrayNonOrderedUpdates<Element> {
        let leftSet = Set(lhs)
        let rightSet = Set(rhs)
        let differences = leftSet.symmetricDifference(rightSet)
        let added = rightSet.intersection(differences)
        let removed = leftSet.intersection(differences)
        
        return ArrayNonOrderedUpdates(Array<Element>(added), Array<Element>(removed))
    }
}
