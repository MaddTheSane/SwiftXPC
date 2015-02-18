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
	
	// MARK: Activity dictionary keys
	public class var intervalKey: String {
		return String.fromCString(XPC_ACTIVITY_INTERVAL)!
	}
	
	public class var gracePeriodKey: String {
		return String.fromCString(XPC_ACTIVITY_GRACE_PERIOD)!
	}
	
	public class var priorityKey: String {
		return String.fromCString(XPC_ACTIVITY_PRIORITY)!
	}
	
	public class var allowBatteryKey: String {
		return String.fromCString(XPC_ACTIVITY_ALLOW_BATTERY)!
	}
	
	public class var requiresScreenSleepKey: String {
		return String.fromCString(XPC_ACTIVITY_REQUIRE_SCREEN_SLEEP)!
	}
	
	public class var requiredBatteryLevelKey: String {
		return String.fromCString(XPC_ACTIVITY_REQUIRE_BATTERY_LEVEL)!
	}
	
	public class var requiresHardDriveSpinningKey: String {
		return String.fromCString(XPC_ACTIVITY_REQUIRE_HDD_SPINNING)!
	}
	
	public class var activityRepeating: String {
		return String.fromCString(XPC_ACTIVITY_REPEATING)!
	}
	
	public class var activityDelay: String {
		return String.fromCString(XPC_ACTIVITY_DELAY)!
	}
	
	private struct Static {
		static var onceToken: dispatch_once_t = 0
		static var anInterval1Minute: XPCInt!
		static var anInterval5Minutes: XPCInt!
		static var anInterval15Minutes: XPCInt!
		static var anInterval30Minutes: XPCInt!
		static var anInterval1Hour: XPCInt!
		static var anInterval4Hours: XPCInt!
		static var anInterval8Hours: XPCInt!
		static var anInterval1Day: XPCInt!
		static var anInterval7Days: XPCInt!
	}

	private class func setupIntervals() {
		dispatch_once(&Static.onceToken) {
			Static.anInterval1Minute = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_MIN)
			Static.anInterval5Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_5_MIN)
			Static.anInterval15Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_15_MIN)
			Static.anInterval30Minutes = XPCInt(value: XPC_ACTIVITY_INTERVAL_30_MIN)
			Static.anInterval1Hour = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_HOUR)
			Static.anInterval4Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_4_HOURS)
			Static.anInterval8Hours = XPCInt(value: XPC_ACTIVITY_INTERVAL_8_HOURS)
			Static.anInterval1Day = XPCInt(value: XPC_ACTIVITY_INTERVAL_1_DAY)
			Static.anInterval7Days = XPCInt(value: XPC_ACTIVITY_INTERVAL_7_DAYS)
		}
	}
	
	public class var interval1Minute: XPCInt {
		setupIntervals()
		return Static.anInterval1Minute
	}
	public class var interval5Minutes: XPCInt {
		setupIntervals()
		return Static.anInterval5Minutes
	}
	public class var interval15Minutes: XPCInt {
		setupIntervals()
		return Static.anInterval15Minutes
	}
	public class var interval30Minutes: XPCInt {
		setupIntervals()
		return Static.anInterval30Minutes
	}
	public class var interval1Hour: XPCInt {
		setupIntervals()
		return Static.anInterval1Hour
	}

	public class var interval4Hours: XPCInt {
		setupIntervals()
		return Static.anInterval4Hours
	}
	
	public class var interval8Hours: XPCInt {
		setupIntervals()
		return Static.anInterval8Hours
	}
	
	public class var interval1Day: XPCInt {
		setupIntervals()
		return Static.anInterval1Day
	}
	
	public class var interval7Days: XPCInt {
		setupIntervals()
		return Static.anInterval7Days
	}

	public class var priorityMaintenance: XPCString {
		return XPCString(cString: XPC_ACTIVITY_PRIORITY_MAINTENANCE)
	}
	
	public class var priorityUtility: XPCString {
		return XPCString(cString: XPC_ACTIVITY_PRIORITY_UTILITY)
	}
}
