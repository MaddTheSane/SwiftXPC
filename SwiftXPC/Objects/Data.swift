//
//  Data.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public class XPCData : XPCObject {
    required public convenience init(blob: NSData) {
        self.init(nativePointer: xpc_data_create(blob.bytes, UInt(blob.length)))
    }
    
    required public convenience init(text: String) {
        let blob = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        self.init(blob: blob!)
    }
    
    public var length: Int {
    get {
        return Int(xpc_data_get_length(objectPointer))
    }
    }
    
    public func readData(offset: Int = 0) -> NSData? {
        if let data = NSMutableData(length: self.length) {
            xpc_data_get_bytes(objectPointer, data.mutableBytes, UInt(offset), UInt(self.length))
            return NSData(data: data)
        } else {
            return nil
        }
    }
}
