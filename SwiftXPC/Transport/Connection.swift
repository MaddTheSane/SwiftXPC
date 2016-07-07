//
//  Connection.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import Dispatch
import XPC

public final class XPCConnection : XPCObject {
    public class func createAnonymousConnection() -> XPCConnection {
        return XPCConnection(anonymous: ())
    }
    
    public convenience init(name: String, queue: DispatchQueue? = nil) {
        self.init(nativePointer: xpc_connection_create(name, queue))
    }
    
    public convenience init(anonymous: ()) {
        self.init(nativePointer: xpc_connection_create(nil, nil))
    }
    
    public convenience init(endpoint: XPCEndpoint) {
        self.init(nativePointer: xpc_connection_create_from_endpoint(endpoint.objectPointer))
    }
    
    public func set(target queue: DispatchQueue?) {
        xpc_connection_set_target_queue(objectPointer, queue)
    }
    
    public func set(handler block: (XPCObject) -> ()) {
        xpc_connection_set_event_handler(objectPointer) {
            ptr in
            block(nativeTypeForXPCObject(ptr))
        }
    }
    
    public func suspend() {
        xpc_connection_suspend(objectPointer)
    }
    
    public func resume() {
        xpc_connection_resume(objectPointer)
    }
    
    public func send(message: XPCDictionary) {
        xpc_connection_send_message(objectPointer, message.objectPointer)
    }
    
    public func send(message: XPCDictionary, replyHandler: (XPCObject) -> ()) {
        xpc_connection_send_message_with_reply(objectPointer, message.objectPointer, nil) {
            obj in
            replyHandler(nativeTypeForXPCObject(obj))
        }
    }
    
    public func send(barrier: () -> ()) {
        xpc_connection_send_barrier(objectPointer) {
            barrier()
        }
    }
    
    public func cancel() {
        xpc_connection_cancel(objectPointer)
    }
    
    // MARK: Properties
    
    public var name: String? {
        let ptr = xpc_connection_get_name(objectPointer)
        if let ptr = ptr {
            return String(cString: ptr)
        } else {
            return nil
        }
    }
    
    public var effectiveUserIDOfRemotePeer : uid_t {
        return xpc_connection_get_euid(objectPointer)
    }
    
    public var effectiveGroupIDOfRemotePeer : gid_t {
        return xpc_connection_get_egid(objectPointer)
    }
    
    public var processIDOfRemotePeer : pid_t {
        return xpc_connection_get_pid(objectPointer)
    }
    
    public var auditSessionIDOfRemotePeer : au_asid_t {
        return xpc_connection_get_asid(objectPointer)
    }
}

extension XPCDictionary {
    public var remoteConnection: XPCConnection {
        return XPCConnection(nativePointer: xpc_dictionary_get_remote_connection(objectPointer)!)
    }
    
    /// Note: Due to the underlying implementation, this method will only work once.
    /// Subsequent calls will return nil. In addition, if the receiver does not have
    /// a reply context, this method will always return nil.
    public func createReply() -> XPCDictionary? {
        guard let ptr = xpc_dictionary_create_reply(objectPointer) else {
            return nil
        }
        
        return XPCDictionary(nativePointer: ptr)
    }
}
