//
//  Generators.swift
//  SwiftXPC
//
//  Created by C.W. Betts on 8/29/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public struct XPCArrayIterator: IteratorProtocol {
    private let theArray: XPCArray
    private var status: Int
    
    fileprivate init(array: XPCArray) {
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
            let toRet = theArray[status]
            status += 1
            return toRet
        }
    }
}

extension XPCArray: Sequence {
	/// This will attempt to copy any array that is generated, to try and keep the generator as static as possible.
    public func makeIterator() -> XPCArrayIterator {
        return XPCArrayIterator(array: self)
    }
}

extension XPCArray: ExpressibleByArrayLiteral {
    public typealias Element = XPCObject

    public convenience init(arrayLiteral elements: Element...) {
        self.init(objects: elements)
    }
}

public struct XPCDictIterator: IteratorProtocol {
    private let keyArray: [String]
    private let internalDict: [String: XPCObject]
    private var i = 0
    
    public mutating func next() -> (key: String, object: XPCObject)? {
        if i < keyArray.count {
            let key = keyArray[i]
            i += 1
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
            let swiftName = String(cString: name)
            preKeyArray.append(swiftName)
            preDict[swiftName] = nativeTypeForXPCObject(object)
            
            return true
        })
        keyArray = preKeyArray
        internalDict = preDict
    }
}

extension XPCDictionary: ExpressibleByDictionaryLiteral, Sequence {
    public typealias Key = String
    public typealias Value = XPCObject
    public typealias Iterator = XPCDictIterator
    
    public convenience init(dictionaryLiteral elements: (String, XPCObject)...) {
        self.init()
        for (key, value) in elements {
            self[key] = value
        }
    }
    
    public func makeIterator() -> XPCDictIterator {
        return XPCDictIterator(dictionary: self)
    }
}
