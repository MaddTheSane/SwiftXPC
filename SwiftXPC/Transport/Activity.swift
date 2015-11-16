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
        ///Refer to `XPC_ACTIVITY_STATE_CHECK_IN`.
        case CheckIn
        ///Refer to `XPC_ACTIVITY_STATE_WAIT`.
        case Wait
        ///Refer to `XPC_ACTIVITY_STATE_RUN`.
        case Run
        ///Refer to `XPC_ACTIVITY_STATE_DEFER`.
        case Defer
        ///Refer to `XPC_ACTIVITY_STATE_CONTINUE`.
        case Continue
        ///Refer to `XPC_ACTIVITY_STATE_DONE`.
        case Done
    }
   
    public class var checkIn: XPCDictionary {
        return XPCDictionary(nativePointer: XPC_ACTIVITY_CHECK_IN)
    }
    
    public class func register(identifier: String, criteria: XPCDictionary = checkIn, handler outerHandle: XPCActivityHandler) {
        xpc_activity_register(identifier, criteria.objectPointer) { (innerHandler) -> Void in
            let activity = XPCActivity(nativePointer: innerHandler)
            outerHandle(activity)
        }
    }
    
    /// Unregisters an activity found by its identifier.
    public class func deregister(identifier: String) {
        xpc_activity_unregister(identifier)
    }
    
    public var state: State {
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
        
        if xpc_activity_set_state(objectPointer, toXPC) == false {
            // TODO: throw?
            //throw NSError(domain: "", code: 0, userInfo: nil)
        }
    }
    }
    
    public var criteria: XPCDictionary? {
    get {
        guard let aCri = xpc_activity_copy_criteria(objectPointer) else {
            return nil
        }
        return XPCDictionary(nativePointer: aCri)
    }
    set {
        guard let newVal = newValue else {
            return
        }
        xpc_activity_set_criteria(objectPointer, newVal.objectPointer)
    }
    }
    
    public var shouldDefer: Bool {
        return xpc_activity_should_defer(objectPointer)
    }
	
	// MARK: Activity dictionary keys
	public static let intervalKey: String = {
		return String(XPC_ACTIVITY_INTERVAL)
	}()
	
	public static let gracePeriodKey: String = {
		return String(XPC_ACTIVITY_GRACE_PERIOD)
	}()
	
	public static let priorityKey: String = {
		return String(XPC_ACTIVITY_PRIORITY)
	}()
	
	public static let allowBatteryKey: String = {
		return String(XPC_ACTIVITY_ALLOW_BATTERY)
	}()
	
	public static let requiresScreenSleepKey: String = {
		return String(XPC_ACTIVITY_REQUIRE_SCREEN_SLEEP)
	}()
	
    /*
	public class var requiredBatteryLevelKey: String {
		return String.fromCString(XPC_ACTIVITY_REQUIRE_BATTERY_LEVEL)!
	}
	
	public class var requiresHardDriveSpinningKey: String {
		return String.fromCString(XPC_ACTIVITY_REQUIRE_HDD_SPINNING)!
	}*/
	
	public static let activityRepeating: String = {
		return String(XPC_ACTIVITY_REPEATING)
	}()
	
	public static let activityDelay: String = {
		return String(XPC_ACTIVITY_DELAY)
	}()
	
	public static let interval1Minute = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_MIN)
	public static let interval5Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_5_MIN)
	public static let interval15Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_15_MIN)
	public static let interval30Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_30_MIN)
	public static let interval1Hour = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_HOUR)
	public static let interval4Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_4_HOURS)
	public static let interval8Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_8_HOURS)
	public static let interval1Day = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_DAY)
	public static let interval7Days = XPCInt(value: XPC_ACTIVITY_INTERVAL_7_DAYS)
    
	public static let priorityMaintenance: XPCString = {
		return XPCString(cString: XPC_ACTIVITY_PRIORITY_MAINTENANCE)
	}()
	
	public static let priorityUtility: XPCString = {
		return XPCString(cString: XPC_ACTIVITY_PRIORITY_UTILITY)
	}()
}
