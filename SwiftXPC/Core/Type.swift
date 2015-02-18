//
//  Connection.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public final class XPCObjectType : Equatable {
    private let objectPointer : xpc_type_t
    
    internal init(nativePointer: xpc_type_t) {
        objectPointer = nativePointer
    }
    
    public class var connection: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetConnectionType())
    }
    
    public class var endpoint: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetEndpointType())
    }
    
    public class var activity: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetActivityType())
    }
    
    public class var nullPointer: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetNullType())
    }
    
    public class var boolean: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetBooleanType())
    }
    
    public class var integer: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetInt64Type())
    }
    
    public class var unsignedInteger: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetUInt64Type())
    }
    
    public class var floatingPoint: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetDoubleType())
    }
    
    public class var date: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetDateType())
    }
    
    public class var data: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetDataType())
    }
    
    public class var string: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetStringType())
    }
    
    public class var UUID: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetUUIDType())
    }
    
    public class var fileDescriptor: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetFileDescriptorType())
    }
    
    public class var sharedMemoryRegion: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetSharedMemoryType())
    }
    
    public class var array: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetArrayType())
    }
    
    public class var dictionary: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetDictionaryType())
    }
    
    public class var error: XPCObjectType {
        return XPCObjectType(nativePointer: XPCShimGetErrorType())
    }
}

public func ==(lhs: XPCObjectType, rhs: XPCObjectType) -> Bool {
    return lhs.objectPointer == rhs.objectPointer
}
