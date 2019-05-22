//
//  ArrayDiffTest.swift
//  AQI macOSTests
//
//  Created by Fernando Mata on 5/22/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import XCTest
@testable import AQI_macOS

class ArrayDiffTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: Ordered diff performance tests
    func testOrderedAddedDiffs() {
        let first = [Int](0...10000)
        let second = [Int](8000...15000)
        // This is an example of a performance test case.
        var result: ArrayOrderedUpdates<Int> = ([], [])
        self.measure {
            result = Array.diffArraysOrdered(lhs: first, rhs: second)
        }
        
        XCTAssertEqual(result.added, [Int](10001...15000))
    }
    
    func testOrderedRemovedDiffs() {
        let first = [Int](0...10000)
        let second = [Int](8000...15000)
        // This is an example of a performance test case.
        var result: ArrayOrderedUpdates<Int> = ([], [])
        self.measure {
            result = Array.diffArraysOrdered(lhs: first, rhs: second)
        }
        
        XCTAssertEqual(result.removed, [Int](0...7999))
    }
    
    func testShuffledArrayDiff() {
        let first = [Int](0...10000).shuffled()
        let second = [Int](8000...15000).shuffled()
        // This is an example of a performance test case.
        var result: ArrayOrderedUpdates<Int> = ([], [])
        self.measure {
            result = Array.diffArraysOrdered(lhs: first, rhs: second)
        }
        
        // Sort array to compare with the result
        let resortedArray = result.added.sorted(by: { $0 < $1 })
        XCTAssertEqual(resortedArray, [Int](10001...15000))
    }
    
    func testShuffledRemoveDiff() {
        let first = [Int](0...10000).shuffled()
        let second = [Int](8000...15000).shuffled()
        // This is an example of a performance test case.
        var result: ArrayOrderedUpdates<Int> = ([], [])
        self.measure {
            result = Array.diffArraysOrdered(lhs: first, rhs: second)
        }
        
        // Sort array to compare with the result
        let resortedArray = result.removed.sorted(by: { $0 < $1 })
        XCTAssertEqual(resortedArray, [Int](0...7999))
    }

    // MARK: Non-ordered diff performance tests
    func testNonOrderedAddedDiffs() {
        let first = [Int](0...10000)
        let second = [Int](8000...15000)
        // This is an example of a performance test case.
        var result: ArrayOrderedUpdates<Int> = ([], [])
        self.measure {
            result = Array.diffArrays(lhs: first, rhs: second)
        }
        
        let resortedArray = result.added.sorted(by: { $0 < $1 })
        XCTAssertEqual(resortedArray, [Int](10001...15000))
    }
    
    func testNonOrderedRemovedDiffs() {
        let first = [Int](0...10000)
        let second = [Int](8000...15000)
        // This is an example of a performance test case.
        var result: ArrayOrderedUpdates<Int> = ([], [])
        self.measure {
            result = Array.diffArrays(lhs: first, rhs: second)
        }
        
        // Sort array to compare with the result
        let resortedArray = result.removed.sorted(by: { $0 < $1 })
        XCTAssertEqual(resortedArray, [Int](0...7999))
    }
    
    func testNonOrderedShuffledArrayDiff() {
        let first = [Int](0...10000).shuffled()
        let second = [Int](8000...15000).shuffled()
        // This is an example of a performance test case.
        var result: ArrayOrderedUpdates<Int> = ([], [])
        self.measure {
            result = Array.diffArrays(lhs: first, rhs: second)
        }
        
        // Sort array to compare with the result
        let resortedArray = result.added.sorted(by: { $0 < $1 })
        XCTAssertEqual(resortedArray, [Int](10001...15000))
    }
    
    func testNonOrderedShuffledRemoveDiff() {
        let first = [Int](0...10000).shuffled()
        let second = [Int](8000...15000).shuffled()
        // This is an example of a performance test case.
        var result: ArrayOrderedUpdates<Int> = ([], [])
        self.measure {
            result = Array.diffArrays(lhs: first, rhs: second)
        }
        
        // Sort array to compare with the result
        let resortedArray = result.removed.sorted(by: { $0 < $1 })
        XCTAssertEqual(resortedArray, [Int](0...7999))
    }
}
