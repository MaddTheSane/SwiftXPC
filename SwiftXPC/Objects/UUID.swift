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
    public convenience init(UUID: Foundation.UUID) {
        var aNSUUIDBytes = [UInt8](repeating: 0, count: 16)
        (UUID as NSUUID).getBytes(&aNSUUIDBytes)
        self.init(nativePointer: xpc_uuid_create(aNSUUIDBytes))
    }
    
    public convenience init(UUID: CFUUID) {
        let uuidStr = CFUUIDCreateString(kCFAllocatorDefault, UUID) as String
        let ourUUID = Foundation.UUID(uuidString: uuidStr)!
        self.init(UUID: ourUUID)
    }
    
    public convenience init?(UUIDString: String) {
        if let ourUUID = Foundation.UUID(uuidString: UUIDString) {
            self.init(UUID: ourUUID)
        } else {
            self.init(UUID: Foundation.UUID())
            
            return nil
        }
    }
    
    public convenience init() {
        self.init(UUID: Foundation.UUID())
    }
    
    public var UUID: Foundation.UUID {
        let ourBytes = xpc_uuid_get_bytes(objectPointer)
        return (Foundation.NSUUID(uuidBytes: ourBytes) as Foundation.UUID)
    }
    
    public var stringValue: String {
        return UUID.uuidString
    }
    
    public class func generateUUID() -> XPCUUID {
        return XPCUUID()
    }
    
    override public var description: String {
        return "UUID: \(stringValue)"
    }
}
