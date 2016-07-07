//
//  SwiftXPC_Tests.swift
//  SwiftXPC Tests
//
//  Created by C.W. Betts on 12/21/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Cocoa
import XCTest
@testable import SwiftXPC

class SwiftXPC_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStringInit() {
        let aStr: XPCString = "Hello"
        let bStr = XPCString(string: "Hello")
        let cStr: XPCString = "Hello!"
        
        XCTAssertEqual(aStr, bStr, "How!?")
        XCTAssertNotEqual(cStr, bStr, "How!?")
    }
    
    func testScalarInit() {
        let aNum: XPCInt = 5
        var bNum = XPCInt(value: 5)
        
        XCTAssertEqual(aNum, bNum, "How!?")
        
        var aDouble: XPCDouble = 5
        
    }
    
    func testCopy() {
        let aNum: XPCInt = 5

        let bNum = aNum.copy()
        if let aBNum = bNum as? XPCInt {
            XCTAssertEqual(aNum, aBNum, "How!?")
        } else {
            XCTAssert(false, "oops")
        }
    }
    
    func testComplexInit() {
        var anArray: XPCArray = [XPCInt(value: 5), XPCInt(value: 3), XPCUInt(value: 5)]
        var aDict: XPCDictionary = ["String": XPCString(string: "value")]
    }
    
    func testDictGenerator() {
        let aDict: XPCDictionary = ["String": XPCString(string: "value"), "A Number": XPCInt(value: 5)]

        for (key, obj) in aDict {
            print("\(key): \(obj.description)")
        }
        
        XCTAssertEqual(aDict["String"], XPCString(string: "value"))
    }
}
