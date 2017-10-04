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
    public convenience init(uuid UUID: Foundation.UUID) {
        var tmpUUIDByptes = UUID.uuid
        let aNSUUIDBytes = withUnsafeBytes(of: &tmpUUIDByptes) { (someBytes) -> [UInt8] in
            Array(UnsafeBufferPointer(start: someBytes.baseAddress?.bindMemory(to: UInt8.self, capacity: someBytes.count), count: someBytes.count))
        }
        self.init(nativePointer: xpc_uuid_create(aNSUUIDBytes))
    }
    
    public convenience init(uuid: CFUUID) {
        let uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuid) as String
        let ourUUID = Foundation.UUID(uuidString: uuidStr)!
        self.init(uuid: ourUUID)
    }
    
    public convenience init?(uuidString: String) {
        if let ourUUID = Foundation.UUID(uuidString: uuidString) {
            self.init(uuid: ourUUID)
        } else {
            return nil
        }
    }
    
    public convenience init() {
        self.init(uuid: Foundation.UUID())
    }
    
    public var uuid: Foundation.UUID {
        let ourBytes = xpc_uuid_get_bytes(objectPointer)!
        return (Foundation.NSUUID(uuidBytes: ourBytes) as Foundation.UUID)
    }
    
    public var stringValue: String {
        return uuid.uuidString
    }
    
    public class func generateUUID() -> XPCUUID {
        return XPCUUID()
    }
    
    override public var description: String {
        return "UUID: \(stringValue)"
    }
}

// Deprecated
extension XPCUUID {
    @available(*, unavailable, renamed: "uuid")
    public var UUID: Foundation.UUID {
        fatalError()
    }
    
    @available(*, unavailable, renamed: "init(uuid:)")
    public convenience init(UUID: Foundation.UUID) {
        fatalError()
    }
    
    @available(*, unavailable, renamed: "init(uuid:)")
    public convenience init(UUID: CFUUID) {
        fatalError()
    }
    
    @available(*, unavailable, renamed: "init(uuidString:)")
    public convenience init?(UUIDString: String) {
        fatalError()
    }
}
