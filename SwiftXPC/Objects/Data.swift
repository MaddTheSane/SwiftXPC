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
    
    public func readData(_ offset: Int = 0) -> Data? {
        guard let data = NSMutableData(length: self.length) else {
            return nil
        }
        let aCopied = xpc_data_get_bytes(objectPointer, data.mutableBytes, offset, self.length)
        data.length = aCopied
        return (NSData(data: data as Data) as Data)
    }
    
    override public var description: String {
        return "XPC data, \(length) bytes"
    }
}
