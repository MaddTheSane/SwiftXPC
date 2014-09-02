//
//  Integer.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public final class XPCNull : XPCObject {
    public convenience init() {
        self.init(nativePointer: xpc_null_create())
    }
}

public final class XPCBool : XPCObject, BooleanLiteralConvertible, BooleanType {
    public convenience init(value: Bool) {
        self.init(nativePointer: xpc_bool_create(value))
    }
    
    public var value: Bool {
    get {
        return xpc_bool_get_value(objectPointer)
    }
    }
    
    public class func convertFromBooleanLiteral(value: Bool) -> XPCBool {
        return XPCBool(value: value)
    }
    
    public var boolValue: Bool {
    get {
        return value
    }
    }
}

public final class XPCInt : XPCObject, IntegerLiteralConvertible {
    public typealias IntegerLiteralType = Int64
    
    public convenience init(value: Int) {
        self.init(nativePointer: xpc_int64_create(Int64(value)))
    }
    
    required public convenience init(value: Int64) {
        self.init(nativePointer: xpc_int64_create(value))
    }
    
    public class func convertFromIntegerLiteral(value: IntegerLiteralType) -> Self {
        return self(value: value)
    }
    
    public var value: Int {
    get {
        return Int(xpc_int64_get_value(objectPointer))
    }
    }
}

public final class XPCUInt : XPCObject, IntegerLiteralConvertible {
    public typealias IntegerLiteralType = UInt64
    
    public convenience init(value: UInt) {
        self.init(nativePointer: xpc_uint64_create(UInt64(value)))
    }
    
    required public convenience init(value: UInt64) {
        self.init(nativePointer: xpc_uint64_create(value))
    }
    
    public class func convertFromIntegerLiteral(value: IntegerLiteralType) -> Self {
        return self(value: value)
    }
    
    public var value: UInt {
    get {
        return UInt(xpc_uint64_get_value(objectPointer))
    }
    }
}

public final class XPCDouble : XPCObject, IntegerLiteralConvertible {
    public typealias IntegerLiteralType = Double
    
    required public convenience init(value: Double) {
        self.init(nativePointer: xpc_double_create(value))
    }
    
    public class func convertFromIntegerLiteral(value: IntegerLiteralType) -> Self {
        return self(value: value)
    }
    
    public var value: Double {
    get {
        return xpc_double_get_value(objectPointer)
    }
    }
}
