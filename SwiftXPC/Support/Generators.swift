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

extension XPCArray: SequenceType {
	/// This will attempt to copy any array that is generated, to try and keep the generator as static as possible.
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

extension XPCDictionary: DictionaryLiteralConvertible {
    typealias Key = String
    typealias Value = XPCObject
    
    public convenience init(dictionaryLiteral elements: (String, XPCObject)...) {
        self.init()
        for (key, value) in elements {
            self[key] = value
        }
    }
}
