//
//  SwiftXPC_Tests.swift
//  SwiftXPC Tests
//
//  Created by C.W. Betts on 12/21/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Cocoa
import XCTest
import SwiftXPC

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
        var aStr: XPCString = "Hello"
        let bStr = XPCString(string: "Hello")
        
        XCTAssert(aStr == bStr, "How!?")
    }
    
    func testScalarInit() {
        var aNum: XPCInt = 5
        var bNum = XPCInt(value: 5)
        
        XCTAssert(aNum == bNum, "How!?")
    }
}
