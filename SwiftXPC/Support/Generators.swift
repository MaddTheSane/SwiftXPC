//
//  Generators.swift
//  SwiftXPC
//
//  Created by C.W. Betts on 8/29/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public struct XPCArrayGenerator: GeneratorType {
    private let theArray: XPCArray
    private var status: Int
    private init(array: XPCArray) {
        status = 0
        if let copiedArray = array.copy() as? XPCArray {
            theArray = copiedArray
        } else {
            theArray = array
        }
    }
    
    mutating public func next() -> XPCObject? {
        if status >= theArray.count {
            return nil
        } else {
            return theArray[status++]
        }
    }
}

/// This will copy any array that is generated, to try and keep the array as static as possible.
extension XPCArray: SequenceType {
    public func generate() -> XPCArrayGenerator {
        return XPCArrayGenerator(array: self)
    }
}

extension XPCArray: ArrayLiteralConvertible {
    typealias Element = XPCObject

    convenience public init(arrayLiteral elements: XPCObject...) {
        self.init(objects: elements)
    }
}
