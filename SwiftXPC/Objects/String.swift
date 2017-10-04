//
//  String.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public final class XPCString : XPCObject, ExpressibleByStringLiteral {
    public convenience init(string contents: String, encoding: String.Encoding) {
        let byteCount = contents.lengthOfBytes(using: encoding) + 1
        var buffer = [CChar](repeating: CChar(0), count: byteCount)
        _ = contents.getCString(&buffer, maxLength: byteCount, encoding: encoding)
        
        self.init(nativePointer: xpc_string_create(buffer))
    }
    
    public convenience init(string contents: String) {
        self.init(nativePointer: xpc_string_create(contents))
    }
    
    ///Used internally
    internal convenience init(cString: UnsafePointer<CChar>) {
        self.init(nativePointer: xpc_string_create(cString));
    }
    
    public var length: Int {
        return xpc_string_get_length(objectPointer)
    }
    
    public var value: String {
        return String(cString: xpc_string_get_string_ptr(objectPointer)!)
    }
    
    public convenience init(stringLiteral value: String) {
        self.init(string: value)
    }
	
    public convenience init(unicodeScalarLiteral value: String) {
        let outString = String(unicodeScalarLiteral: value)
        self.init(string: outString)
    }
    
    public convenience init(extendedGraphemeClusterLiteral value: String) {
        let outString = String(extendedGraphemeClusterLiteral: value)
        self.init(string: outString)
    }
    
    override public var description: String {
        return "String: (\"\(value)\")"
    }
}
