//
//  AsyncOperation.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/6/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    enum State: String {
        case Ready, Executing, Finished
        
        public var keyPath: String {
            return "is" + rawValue;
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    override var isReady: Bool {
        return super.isReady && state == .Ready
    }
    
    override var isFinished: Bool {
        return state == .Finished
    }
    
    override var isExecuting: Bool {
        return state == .Executing
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if (isCancelled) {
            state = .Finished
            return;
        }
        
        main()
        state = .Executing
    }
    
    override func cancel() {
        state = .Finished
    }
}

