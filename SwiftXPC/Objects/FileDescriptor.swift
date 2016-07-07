//
//  FileDescriptor.swift
//  DOS Prompt
//
//  Created by William Kent on 7/28/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

import Foundation
import XPC

public final class XPCFileDescriptor : XPCObject {
    public convenience init(fileHandle: FileHandle) {
        self.init(nativePointer: xpc_fd_create(fileHandle.fileDescriptor)!)
    }
    
    public convenience init?(fileDescriptor: Int32) {
        if let xpcFD = xpc_fd_create(fileDescriptor) {
            self.init(nativePointer: xpcFD)
        } else {
            self.init(nativePointer: xpc_null_create())
            
            return nil
        }
    }
    
    public var fileHandle : FileHandle {
        return FileHandle(fileDescriptor: xpc_fd_dup(objectPointer), closeOnDealloc: true)
    }
    
    override public var description: String {
        return fileHandle.description
    }
}
