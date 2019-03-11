//
//  AsyncOperation.swift
//  SP_Test
//
//  Created by Hoof on 3/8/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//


import Foundation

class AsyncOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }
    
    var _isFinished: Bool = false
    
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
        
        get {
            return _isFinished
        }
    }
    
    var _isExecuting: Bool = false
    
    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
        
        get {
            return _isExecuting
        }
    }
    
    func execute() {
    }
    
    override func start() {
        isExecuting = true
        execute()
        /* Subclass is responsible for setting isExecuting = false, isFinished = true */
    }
}
