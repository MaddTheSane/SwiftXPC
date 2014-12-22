//
//  Object.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public let XPCApiVersion = XPC_API_VERSION

internal func nativeTypeForXPCObject(object: xpc_object_t) -> XPCObject {
    let objType = XPCObjectType(nativePointer: xpc_get_type(object))
    if objType == XPCObjectType.array() {
        return XPCArray(nativePointer: object)
    } else if objType == XPCObjectType.activity() {
        return XPCActivity(nativePointer: object)
    } else if objType == XPCObjectType.boolean() {
        return XPCBool(nativePointer: object)
    } else if objType == XPCObjectType.connection() {
        return XPCConnection(nativePointer: object)
    } else if objType == XPCObjectType.data() {
        return XPCData(nativePointer: object)
    } else if objType == XPCObjectType.date() {
        return XPCDate(nativePointer: object)
    } else if objType == XPCObjectType.dictionary() {
        return XPCDictionary(nativePointer: object)
    } else if objType == XPCObjectType.endpoint() {
        return XPCEndpoint(nativePointer: object)
    } else if objType == XPCObjectType.error() {
        return XPCDictionary(nativePointer: object)
    } else if objType == XPCObjectType.fileDescriptor() {
        return XPCFileDescriptor(nativePointer: object)
    } else if objType == XPCObjectType.floatingPoint() {
        return XPCDouble(nativePointer: object)
    } else if objType == XPCObjectType.integer() {
        return XPCInt(nativePointer: object)
    } else if objType == XPCObjectType.nullPointer() {
        return XPCNull(nativePointer: object)
    } else if objType == XPCObjectType.sharedMemoryRegion() {
        return XPCSharedMemoryRegion(nativePointer: object)
    } else if objType == XPCObjectType.string() {
        return XPCString(nativePointer: object)
    } else if objType == XPCObjectType.unsignedInteger() {
        return XPCUInt(nativePointer: object)
    } else if objType == XPCObjectType.UUID() {
        return XPCUUID(nativePointer: object)
    } else {
        //Unknown or unsupported type
        return XPCObject(nativePointer: object)
    }
}

public class XPCObject : Hashable, Printable {
    internal var objectPointer : xpc_object_t
    
    internal init(nativePointer: xpc_object_t) {
        objectPointer = nativePointer
    }
    
    public var XPCType: XPCObjectType {
        return XPCObjectType(nativePointer: xpc_get_type(objectPointer))
    }
    
    public func copy() -> XPCObject? {
        if let copyPointer = xpc_copy(objectPointer) {
            return nativeTypeForXPCObject(copyPointer)
        } else {
            return nil
        }
    }
    
    public var hashValue: Int {
        return Int(xpc_hash(objectPointer))
    }
    
    public var description: String {
        var nativeDesc = xpc_copy_description(objectPointer)
        let parsedDesc = String.fromCString(nativeDesc)
        free(nativeDesc)
        
        if let realDesc = parsedDesc {
            return realDesc
        } else {
            return "(description unavailable)"
        }
    }
}

public func ==(lhs: XPCObject, rhs: XPCObject) -> Bool {
    return xpc_equal(lhs.objectPointer, rhs.objectPointer)
}
