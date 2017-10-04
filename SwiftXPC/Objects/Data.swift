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
    public convenience init(blob: Data) {
        self.init(nativePointer: xpc_data_create((blob as NSData).bytes, blob.count))
    }
    
    public convenience init(text: String) {
        let blob = text.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        self.init(blob: blob)
    }
    
    public var length: Int {
        return xpc_data_get_length(objectPointer)
    }
    
    public func readData(fromOffset offset: Int = 0) -> Data? {
        var data = Data(count: self.length)
        let aCopied = data.withUnsafeMutableBytes { (ptr: UnsafeMutablePointer<UInt8>) -> Int in
            return xpc_data_get_bytes(objectPointer, ptr, offset, self.length)
        }
        data.count = aCopied
        return data
    }
    
    override public var description: String {
        return "XPC data, \(length) bytes"
    }
}
