//
//  Integer.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public func <=(lhs: XPCInt, rhs: XPCInt) -> Bool {
    return lhs.value <= rhs.value
}

public func >=(lhs: XPCInt, rhs: XPCInt) -> Bool {
    return lhs.value >= rhs.value
}

public func >(lhs: XPCInt, rhs: XPCInt) -> Bool {
    return lhs.value > rhs.value
}

public func ==(lhs: XPCInt, rhs: XPCInt) -> Bool {
    return (lhs as XPCObject) == (rhs as XPCObject)
}

public func <(lhs: XPCInt, rhs: XPCInt) -> Bool {
    return lhs.value < rhs.value
}

public func <=(lhs: XPCUInt, rhs: XPCUInt) -> Bool{
    return lhs.value <= rhs.value
}

public func >=(lhs: XPCUInt, rhs: XPCUInt) -> Bool {
    return lhs.value >= rhs.value
}

public func >(lhs: XPCUInt, rhs: XPCUInt) -> Bool {
    return lhs.value > rhs.value
}

public func ==(lhs: XPCUInt, rhs: XPCUInt) -> Bool {
    return (lhs as XPCObject) == (rhs as XPCObject)
}

public func <(lhs: XPCUInt, rhs: XPCUInt) -> Bool {
    return lhs.value < rhs.value
}

public func <=(lhs: XPCDouble, rhs: XPCDouble) -> Bool{
    return lhs.value <= rhs.value
}

public func >=(lhs: XPCDouble, rhs: XPCDouble) -> Bool {
    return lhs.value >= rhs.value
}

public func >(lhs: XPCDouble, rhs: XPCDouble) -> Bool {
    return lhs.value > rhs.value
}

public func ==(lhs: XPCDouble, rhs: XPCDouble) -> Bool {
    return (lhs as XPCObject) == (rhs as XPCObject)
}

public func <(lhs: XPCDouble, rhs: XPCDouble) -> Bool {
    return lhs.value < rhs.value
}

public final class XPCNull : XPCObject, NilLiteralConvertible {
    public convenience init() {
        self.init(nativePointer: xpc_null_create())
    }
    
    public convenience init(nilLiteral: ()) {
        self.init()
    }
}

public final class XPCBool : XPCObject, BooleanLiteralConvertible, BooleanType {
    public convenience init(value: Bool) {
        self.init(nativePointer: xpc_bool_create(value))
    }
    
    public var value: Bool {
        return xpc_bool_get_value(objectPointer)
    }
    
    public convenience init(booleanLiteral value: Bool) {
        self.init(value: value)
    }
    
    public var boolValue: Bool {
        return value
    }
}

public final class XPCInt : XPCObject, IntegerLiteralConvertible, Comparable {
    public convenience init(value: Int) {
        self.init(nativePointer: xpc_int64_create(Int64(value)))
    }
    
    public convenience init(value: Int64) {
        self.init(nativePointer: xpc_int64_create(value))
    }
    
    public convenience init(integerLiteral value: Int) {
        self.init(value: value)
    }
    
    public var value: Int64 {
        return xpc_int64_get_value(objectPointer)
    }
}

public final class XPCUInt : XPCObject, IntegerLiteralConvertible, Comparable {
    public convenience init(value: UInt) {
        self.init(nativePointer: xpc_uint64_create(UInt64(value)))
    }
    
    public convenience init(value: UInt64) {
        self.init(nativePointer: xpc_uint64_create(value))
    }
    
    public convenience init(value: Int) {
        self.init(value: UInt64(value))
    }
    
    public convenience init(integerLiteral value: Int) {
        self.init(value: UInt64(value))
    }
    
    public var value: UInt64 {
        return xpc_uint64_get_value(objectPointer)
    }
}

public final class XPCDouble : XPCObject, IntegerLiteralConvertible, FloatLiteralConvertible, Comparable {
    public convenience init(value: Double) {
        self.init(nativePointer: xpc_double_create(value))
    }
    
    public convenience init(value: Float) {
        self.init(value: Double(value))
    }
    
    public convenience init(integerLiteral: Int) {
        self.init(value: Double(integerLiteral))
    }
    
    public convenience init(floatLiteral value: Double) {
        self.init(value: value)
    }
    
    public var value: Double {
        return xpc_double_get_value(objectPointer)
    }
}
