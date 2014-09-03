//
//  Activity.swift
//  SwiftXPC
//
//  Created by C.W. Betts on 9/3/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

private let XPCActivityStateShim: [xpc_activity_state_t: XPCActivityState] = [XPC_ACTIVITY_STATE_CHECK_IN: .CheckIn,
    XPC_ACTIVITY_STATE_WAIT: .Wait, XPC_ACTIVITY_STATE_RUN: .Run, XPC_ACTIVITY_STATE_DEFER: .Defer, XPC_ACTIVITY_STATE_CONTINUE: .Continue, XPC_ACTIVITY_STATE_DONE: .Done ]

// MARK: Activity dictionary keys
public let activityInterval = String.fromCString(XPC_ACTIVITY_INTERVAL)!
public let activityGracePeriod = String.fromCString(XPC_ACTIVITY_GRACE_PERIOD)!
public let activityPriority = String.fromCString(XPC_ACTIVITY_PRIORITY)!
public let activityAllowBattery = String.fromCString(XPC_ACTIVITY_ALLOW_BATTERY)!
public let activityRequireScreenSleep = String.fromCString(XPC_ACTIVITY_REQUIRE_SCREEN_SLEEP)!
public let activityRequiresBatteryLevel = String.fromCString(XPC_ACTIVITY_REQUIRE_BATTERY_LEVEL)!
public let activityRequiresHardDriveSpinning = String.fromCString(XPC_ACTIVITY_REQUIRE_HDD_SPINNING)!

public let activityRepeating = String.fromCString(XPC_ACTIVITY_REPEATING)!
public let activityDelay = String.fromCString(XPC_ACTIVITY_DELAY)!

public let interval1Minute = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_MIN)
public let interval5Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_5_MIN)
public let interval15Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_15_MIN)
public let interval30Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_30_MIN)
public let interval1Hour = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_HOUR)
public let interval4Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_4_HOURS)
public let interval8Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_8_HOURS)
public let interval1Day = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_DAY)
public let interval7Days = XPCInt(value: XPC_ACTIVITY_INTERVAL_7_DAYS)

public let priorityMaintenance = String.fromCString(XPC_ACTIVITY_PRIORITY_MAINTENANCE)!
public let priorityUtility = String.fromCString(XPC_ACTIVITY_PRIORITY_UTILITY)!

extension XPCDictionary {
    public class var checkIn: XPCDictionary { get {
        return XPCDictionary(nativePointer: XPC_ACTIVITY_CHECK_IN)
        }}
}

public enum XPCActivityState: Int {
    case CheckIn
    case Wait
    case Run
    case Defer
    case Continue
    case Done
}

public typealias XPCActivityHandler = (XPCActivity!) -> Void


public class XPCActivity: XPCObject {
    
    public class func register(identifier: String, criteria: XPCDictionary, handler outerHandle: XPCActivityHandler) {
        xpc_activity_register(identifier.cStringUsingEncoding(NSUTF8StringEncoding)!, criteria.objectPointer) { (innerHandler) -> Void in
            let activity = XPCActivity(nativePointer: innerHandler)
            outerHandle(activity)
        }
    }
    
    public class func deregister(identifier: String) {
        xpc_activity_unregister(identifier.cStringUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    public var state: XPCActivityState {
        get {
            let out = xpc_activity_get_state(objectPointer)
            return XPCActivityStateShim[out]!
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
    
    public var shouldDefer: Bool { get {
        return xpc_activity_should_defer(objectPointer)
        }}
}
