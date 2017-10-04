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
    
    public static let connection: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetConnectionType())
    }()
    
    public static let endpoint: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetEndpointType())
    }()
    
    public static let activity: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetActivityType())
    }()
    
    public static let nullPointer: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetNullType())
    }()
    
    public static let boolean: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetBooleanType())
    }()
    
    public static let integer: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetInt64Type())
    }()
    
    public static let unsignedInteger: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetUInt64Type())
    }()
    
    public static let floatingPoint: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetDoubleType())
    }()
    
    public static let date: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetDateType())
    }()
    
    public static let data: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetDataType())
    }()
    
    public static let string: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetStringType())
    }()
    
    public static let UUID: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetUUIDType())
    }()
    
    public static let fileDescriptor: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetFileDescriptorType())
    }()
    
    public static let sharedMemoryRegion: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetSharedMemoryType())
    }()
    
    public static let array: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetArrayType())
    }()
    
    public static let dictionary: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetDictionaryType())
    }()
    
    public static let error: XPCObjectType = {
        return XPCObjectType(nativePointer: XPCShimGetErrorType())
    }()
    
    public class func ==(lhs: XPCObjectType, rhs: XPCObjectType) -> Bool {
        return lhs.objectPointer == rhs.objectPointer
    }
}
