//
//  Activity.swift
//  SwiftXPC
//
//  Created by C.W. Betts on 9/3/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

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
    
    private let XPCActivityStateShim: [xpc_activity_state_t: XPCActivityState] = [XPC_ACTIVITY_STATE_CHECK_IN: .CheckIn,
    XPC_ACTIVITY_STATE_WAIT: .Wait, XPC_ACTIVITY_STATE_RUN: .Run, XPC_ACTIVITY_STATE_DEFER: .Defer, XPC_ACTIVITY_STATE_CONTINUE: .Continue, XPC_ACTIVITY_STATE_DONE: .Done ]
   
    public class var checkIn: XPCDictionary {
    get {
        return XPCDictionary(nativePointer: XPC_ACTIVITY_CHECK_IN)
    }
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
    
    public var shouldDefer: Bool {
    get {
        return xpc_activity_should_defer(objectPointer)
    }
    }
    
    // MARK: Activity dictionary keys
    #if true
    public class var intervalKey: String {
    get {
        return String.fromCString(XPC_ACTIVITY_INTERVAL)!
    }
    }
    
    public class var gracePeriodKey: String {
    get {
        return String.fromCString(XPC_ACTIVITY_GRACE_PERIOD)!
    }
    }
    
    public class var priorityKey: String {
    get {
        return String.fromCString(XPC_ACTIVITY_PRIORITY)!
    }
    }
    
    public class var allowBatteryKey: String {
    get {
        return String.fromCString(XPC_ACTIVITY_ALLOW_BATTERY)!
    }
    }
    
    public class var requiresScreenSleepKey: String {
    get {
        return String.fromCString(XPC_ACTIVITY_REQUIRE_SCREEN_SLEEP)!
    }
    }
    
    public class var requiredBatteryLevelKey: String {
    get {
        return String.fromCString(XPC_ACTIVITY_REQUIRE_BATTERY_LEVEL)!
    }
    }
    
    public class var requiresHardDriveSpinningKey: String {
    get {
        return String.fromCString(XPC_ACTIVITY_REQUIRE_HDD_SPINNING)!
    }
    }

    
    public class var activityRepeating: XPCString {
    get {
        return XPCString(cString: XPC_ACTIVITY_REPEATING)
    }
    }
    
    public class var activityDelay: XPCString {
    get {
        return XPCString(cString: XPC_ACTIVITY_DELAY)
    }
    }
    
    public class var interval1Minute: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_1_MIN)
    }
    }

    public class var interval5Minutes: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_5_MIN)
    }
    }
    
    public class var interval15Minutes: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_15_MIN)
    }
    }
    
    public class var interval30Minutes: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_30_MIN)
    }
    }
    
    public class var interval1Hour: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_1_HOUR)
    }
    }
    
    public class var interval4Hours: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_4_HOURS)
    }
    }
    
    public class var interval8Hours: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_8_HOURS)
    }
    }
    
    public class var interval1Day: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_1_DAY)
    }
    }
    
    public class var interval7Days: XPCInt {
    get {
        return XPCInt(value: XPC_ACTIVITY_INTERVAL_7_DAYS)
    }
    }
    
    public class var priorityMaintenance: XPCString {
    get {
        return XPCString(cString: XPC_ACTIVITY_PRIORITY_MAINTENANCE)
    }
    }
    
    public class var priorityUtility: XPCString {
    get {
        return XPCString(cString: XPC_ACTIVITY_PRIORITY_UTILITY)
    }
    }
    
    #else
    // MARK: Activity dictionary keys
    public class let intervalKey = String.fromCString(XPC_ACTIVITY_INTERVAL)!
    public class let gracePeriodKey = String.fromCString(XPC_ACTIVITY_GRACE_PERIOD)!
    public class let priorityKey = String.fromCString(XPC_ACTIVITY_PRIORITY)!
    public class let allowBatteryKey = String.fromCString(XPC_ACTIVITY_ALLOW_BATTERY)!
    public class let requiresScreenSleepKey = String.fromCString(XPC_ACTIVITY_REQUIRE_SCREEN_SLEEP)!
    public class let requiredBatteryLevelKey = String.fromCString(XPC_ACTIVITY_REQUIRE_BATTERY_LEVEL)!
    public class let requiresHardDriveSpinningKey = String.fromCString(XPC_ACTIVITY_REQUIRE_HDD_SPINNING)!
    
    public class let activityRepeating = XPCString(cString: XPC_ACTIVITY_REPEATING)
    public class let activityDelay = XPCString(cString: XPC_ACTIVITY_DELAY)
    
    public class let interval1Minute = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_MIN)
    public class let interval5Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_5_MIN)
    public class let interval15Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_15_MIN)
    public class let interval30Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_30_MIN)
    public class let interval1Hour = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_HOUR)
    public class let interval4Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_4_HOURS)
    public class let interval8Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_8_HOURS)
    public class let interval1Day = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_DAY)
    public class let interval7Days = XPCInt(value: XPC_ACTIVITY_INTERVAL_7_DAYS)
    
    public class let priorityMaintenance = XPCString(cString: XPC_ACTIVITY_PRIORITY_MAINTENANCE)
    public class let priorityUtility = XPCString(cString: XPC_ACTIVITY_PRIORITY_UTILITY)
    #endif
}
