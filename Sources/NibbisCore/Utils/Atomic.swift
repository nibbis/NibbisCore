//
//  Atomic.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 1/24/23.
//

import os

@propertyWrapper
public struct Atomic<Value> {

    let lock = OSAllocatedUnfairLock()
    private var value: Value

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return value
        }
        set {
            lock.lock()
            value = newValue
            lock.unlock()
        }
    }
}
