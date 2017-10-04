//
//  Object.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

///The API version of libXPC that SwiftXPC was built on.
public let XPCApiVersion = XPC_API_VERSION

internal func nativeTypeForXPCObject(_ object: xpc_object_t) -> XPCObject {
    let objType = XPCObjectType(nativePointer: xpc_get_type(object))
    switch objType {
    case .array:
        return XPCArray(nativePointer: object)
        
    case .activity:
        return XPCActivity(nativePointer: object)
        
    case .boolean:
        return XPCBool(nativePointer: object)
        
    case .connection:
        return XPCConnection(nativePointer: object)

    case .data:
        return XPCData(nativePointer: object)

    case .date:
        return XPCDate(nativePointer: object)

    case .dictionary, /* Error types are dictionaries*/ .error:
        return XPCDictionary(nativePointer: object)
        
    case .endpoint:
        return XPCEndpoint(nativePointer: object)
        
    case .fileDescriptor:
        return XPCFileDescriptor(nativePointer: object)

    case .floatingPoint:
        return XPCDouble(nativePointer: object)
        
    case .integer:
        return XPCInt(nativePointer: object)

    case .nullPointer:
        return XPCNull(nativePointer: object)
        
    case .sharedMemoryRegion:
        return XPCSharedMemoryRegion(nativePointer: object)
        
    case .string:
        return XPCString(nativePointer: object)
        
    case .unsignedInteger:
        return XPCUInt(nativePointer: object)

    case .UUID:
        return XPCUUID(nativePointer: object)

    default:
        //Unknown or unsupported type
        return XPCObject(nativePointer: object)
    }
}

/// The base class of all objects in the SwiftXPC framework
public class XPCObject : Hashable, CustomStringConvertible, CustomDebugStringConvertible {
    internal var objectPointer : xpc_object_t
    
    internal init(nativePointer: xpc_object_t) {
        objectPointer = nativePointer
    }
    
    public var XPCType: XPCObjectType {
        return XPCObjectType(nativePointer: xpc_get_type(objectPointer))
    }
    
    ///Copy the current object into another object.
    final public func copy() -> XPCObject? {
        guard let copyPointer = xpc_copy(objectPointer) else {
            return nil
        }
        return nativeTypeForXPCObject(copyPointer)
    }
    
    final public var hashValue: Int {
        return xpc_hash(objectPointer)
    }
    
    public var description: String {
        return self.debugDescription
    }
    
    final public var debugDescription: String {
        let nativeDesc = xpc_copy_description(objectPointer)
        defer {
            free(nativeDesc)
        }
        return String(cString: nativeDesc)
    }
}

public func ==(lhs: XPCObject, rhs: XPCObject) -> Bool {
    return xpc_equal(lhs.objectPointer, rhs.objectPointer)
}
