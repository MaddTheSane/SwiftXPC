//
//  Activity.swift
//  SwiftXPC
//
//  Created by C.W. Betts on 9/3/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public typealias XPCActivityHandler = (XPCActivity!) -> Void

private let XPCActivityStateShim: [xpc_activity_state_t: XPCActivity.State] = [XPC_ACTIVITY_STATE_CHECK_IN: .CheckIn,
	XPC_ACTIVITY_STATE_WAIT: .Wait, XPC_ACTIVITY_STATE_RUN: .Run, XPC_ACTIVITY_STATE_DEFER: .Defer,
	XPC_ACTIVITY_STATE_CONTINUE: .Continue, XPC_ACTIVITY_STATE_DONE: .Done ]

final public class XPCActivity: XPCObject {
    
    public enum State {
        case CheckIn
        case Wait
        case Run
        case Defer
        case Continue
        case Done
    }
   
    public class var checkIn: XPCDictionary {
        return XPCDictionary(nativePointer: XPC_ACTIVITY_CHECK_IN)
    }
    
    public class func register(identifier: String, criteria: XPCDictionary = checkIn, handler outerHandle: XPCActivityHandler) {
        xpc_activity_register(identifier.cStringUsingEncoding(NSUTF8StringEncoding)!, criteria.objectPointer) { (innerHandler) -> Void in
            let activity = XPCActivity(nativePointer: innerHandler)
            outerHandle(activity)
        }
    }
    
    public class func deregister(identifier: String) {
        xpc_activity_unregister(identifier.cStringUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    public var state: State {
    get {
        let out = xpc_activity_get_state(objectPointer)
        if let toRet = XPCActivityStateShim[out] {
            return toRet
        } else {
            return .Wait
        }
    }
    set {
        var toXPC: xpc_activity_state_t = 0
        for (i, o) in XPCActivityStateShim {
            if o == newValue {
                toXPC = i
                break
            }
        }
        
        xpc_activity_set_state(objectPointer, toXPC)
    }
    }
    
    public var criteria: XPCDictionary {
    get {
        return XPCDictionary(nativePointer: xpc_activity_copy_criteria(objectPointer))
    }
    set {
        xpc_activity_set_criteria(objectPointer, newValue.objectPointer)
    }
    }
    
    public var shouldDefer: Bool {
        return xpc_activity_should_defer(objectPointer)
    }
    
}

// MARK: Activity dictionary keys
public var intervalKey: String {
    return String.fromCString(XPC_ACTIVITY_INTERVAL)!
}
public var gracePeriodKey: String {
    return String.fromCString(XPC_ACTIVITY_GRACE_PERIOD)!
}
public var priorityKey: String {
    return String.fromCString(XPC_ACTIVITY_PRIORITY)!
}
public var allowBatteryKey: String {
    return String.fromCString(XPC_ACTIVITY_ALLOW_BATTERY)!
}
public var requiresScreenSleepKey: String {
    return String.fromCString(XPC_ACTIVITY_REQUIRE_SCREEN_SLEEP)!
}
public var requiredBatteryLevelKey: String {
    return String.fromCString(XPC_ACTIVITY_REQUIRE_BATTERY_LEVEL)!
}
public var requiresHardDriveSpinningKey: String {
    return String.fromCString(XPC_ACTIVITY_REQUIRE_HDD_SPINNING)!
}

public var activityRepeating: String {
    return String.fromCString(XPC_ACTIVITY_REPEATING)!
}
public var activityDelay: String {
    return String.fromCString(XPC_ACTIVITY_DELAY)!
}

public let interval1Minute = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_MIN)
public let interval5Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_5_MIN)
public let interval15Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_15_MIN)
public let interval30Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_30_MIN)
public let interval1Hour = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_HOUR)
public let interval4Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_4_HOURS)
public let interval8Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_8_HOURS)
public let interval1Day = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_DAY)
public let interval7Days = XPCInt(value: XPC_ACTIVITY_INTERVAL_7_DAYS)

public var priorityMaintenance: XPCString {
    return XPCString(cString: XPC_ACTIVITY_PRIORITY_MAINTENANCE)
}
public var priorityUtility: XPCString {
    return XPCString(cString: XPC_ACTIVITY_PRIORITY_UTILITY)
}
