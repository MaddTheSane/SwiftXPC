//
//  Date.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

private let nanosecondConversion : Int64 = 1_000_000_000

public final class XPCDate : XPCObject {
    public convenience init(value: NSDate) {
        let seconds = Int64(value.timeIntervalSince1970)
        self.init(nativePointer: xpc_date_create(seconds * nanosecondConversion))
    }
    
    public convenience init() {
        self.init(nativePointer: xpc_date_create_from_current())
    }
    
    public var value : NSDate {
        let seconds = xpc_date_get_value(objectPointer)
        let interval = NSTimeInterval(seconds / nanosecondConversion)
        return NSDate(timeIntervalSince1970: interval)
    }
    
    /// The current date and time.
    public class var now : XPCDate {
        return XPCDate()
    }
    
    override public var description: String {
        return value.description
    }
}
