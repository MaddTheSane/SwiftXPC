//
//  Data.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public final class XPCData : XPCObject {
    public convenience init(blob: NSData) {
        self.init(nativePointer: xpc_data_create(blob.bytes, blob.length))
    }
    
    public convenience init(text: String) {
        let blob = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        self.init(blob: blob)
    }
    
    public var length: Int {
        return xpc_data_get_length(objectPointer)
    }
    
    public func readData(offset: Int = 0) -> NSData? {
        guard let data = NSMutableData(length: self.length) else {
            return nil
        }
        let aCopied = xpc_data_get_bytes(objectPointer, data.mutableBytes, offset, self.length)
        data.length = aCopied
        return NSData(data: data)
    }
    
    override public var description: String {
        return "XPC data, \(length) bytes"
    }
}
