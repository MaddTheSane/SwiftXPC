//
//  UUID.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

private let UUIDLength: UInt = (128 / 8)

public final class XPCUUID : XPCObject {
    required public convenience init(UUID: NSUUID) {
        var aNSUUIDBytes = [UInt8](count: 16, repeatedValue: 0)
        UUID.getUUIDBytes(&aNSUUIDBytes)
        self.init(nativePointer: xpc_uuid_create(aNSUUIDBytes))
    }
    
    public convenience init(UUID: CFUUID) {
        var uuidStr = CFUUIDCreateString(kCFAllocatorDefault, UUID) as NSString as String
        var ourUUID = NSUUID(UUIDString: uuidStr)!
        self.init(UUID: ourUUID)
    }
    
    public convenience init?(UUIDString: String) {
        if let ourUUID = NSUUID(UUIDString: UUIDString) {
            self.init(UUID: ourUUID)
        } else {
            self.init(UUID: NSUUID())
            
            return nil
        }
    }
    
    public convenience init() {
        self.init(UUID: NSUUID())
    }
    
    public var UUID: NSUUID {
    get {
        let ourBytes = xpc_uuid_get_bytes(objectPointer)
        return NSUUID(UUIDBytes: ourBytes)
    }
    }
    
    public var stringValue: String {
    get {
        return UUID.UUIDString
    }
    }
    
    public class func generateUUID() -> XPCUUID {
        return XPCUUID(UUID: NSUUID())
    }
}
