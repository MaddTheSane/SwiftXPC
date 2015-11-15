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
    public typealias Element = XPCObject

    public convenience init(arrayLiteral elements: Element...) {
        self.init(objects: elements)
    }
}

public struct XPCDictGenerator: GeneratorType {
    private let keyArray: [String]
    private let internalDict: [String: XPCObject]
    private var i = 0
    
    public mutating func next() -> (key: String, object: XPCObject)? {
        if i < keyArray.count {
            let key = keyArray[i++]
            let obj = internalDict[key]!
            return (key, obj)
        } else {
            return nil
        }
    }
    
    init(dictionary: XPCDictionary) {
        var preKeyArray = [String]()
        var preDict = [String: XPCObject]()
        //We're using xpc_dictionary_apply to iterate over the array
        xpc_dictionary_apply(dictionary.objectPointer, { (name, object) -> Bool in
            let swiftName = String.fromCString(name)!
            preKeyArray.append(swiftName)
            preDict[swiftName] = nativeTypeForXPCObject(object)
            
            return true
        })
        keyArray = preKeyArray
        internalDict = preDict
    }
}

extension XPCDictionary: DictionaryLiteralConvertible, SequenceType {
    public typealias Key = String
    public typealias Value = XPCObject
    public typealias Generator = XPCDictGenerator
    
    public convenience init(dictionaryLiteral elements: (String, XPCObject)...) {
        self.init()
        for (key, value) in elements {
            self[key] = value
        }
    }
    
    public func generate() -> XPCDictGenerator {
        return XPCDictGenerator(dictionary: self)
    }
}
