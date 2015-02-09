//
//  Dictionary.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public final class XPCDictionary : XPCObject {
    public convenience init() {
        self.init(nativePointer: xpc_dictionary_create(nil, nil, 0))
    }
    
    public convenience init(dictionary: [String: XPCObject]) {
        self.init()
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
    public subscript(key: String) -> XPCObject {
        get {
            let buffer = UTFStringArray(key)
            
            return nativeTypeForXPCObject(xpc_dictionary_get_value(objectPointer, buffer))
        }
        
        set {
            let buffer = UTFStringArray(key)
            
            xpc_dictionary_set_value(objectPointer, buffer, newValue.objectPointer)
        }
    }
    
    public var count: Int {
        return Int(xpc_dictionary_get_count(objectPointer))
    }
}
