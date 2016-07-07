//
//  Array.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public final class XPCArray : XPCObject {
    public convenience init() {
        self.init(nativePointer: xpc_array_create(nil, 0))
    }
    
    public convenience init(objects: [XPCObject]) {
        self.init()
        
        for obj in objects {
            append(obj)
        }
    }
    
    public func append(_ value: XPCObject) {
        xpc_array_append_value(objectPointer, value.objectPointer)
    }
    
    public subscript(index: Int) -> XPCObject {
        get {
            let ptr = xpc_array_get_value(objectPointer, index)
            return nativeTypeForXPCObject(ptr)
        }
        set {
            xpc_array_set_value(objectPointer, index, newValue.objectPointer)
        }
    }
    
    public var count: Int {
        return xpc_array_get_count(objectPointer)
    }
}
