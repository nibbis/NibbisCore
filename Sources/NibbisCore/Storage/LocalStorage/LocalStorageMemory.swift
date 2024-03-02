//
//  LocalStorageMemory.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 7/19/21.
//

import Foundation
import os

private let lock = OSAllocatedUnfairLock()
private var memoryMap = [String: AnyHashable]()
private var continuationMap = [String: [UUID: AsyncStream<AnyHashable?>.Continuation]]()

public extension LocalStorage {
    
    static let memory = Self(
        save: { key, value in
            lock.lock()
            let oldValue = memoryMap[key]
            if oldValue != value {
                memoryMap[key] = value
                continuationMap[key]?.values.forEach {
                    $0.yield(value)
                }
            }
            lock.unlock()
        },
        get: { key in
            lock.lock()
            defer { lock.unlock() }
            return memoryMap[key]
        },
        observe: { key in
            AsyncStream<AnyHashable?> { continuation in
                let continuationId = UUID()
                
                lock.lock()
                if var existingContinuation = continuationMap[key] {
                    existingContinuation[continuationId] = continuation
                    continuationMap[key] = existingContinuation
                } else {
                    continuationMap[key] = [continuationId: continuation]
                }
                continuation.yield(memoryMap[key])
                lock.unlock()
                
                continuation.onTermination = { _ in
                    lock.lock()
                    continuationMap[key]?[continuationId] = nil
                    lock.unlock()
                }
            }
        },
        remove: { key in
            lock.lock()
            continuationMap[key]?.values.forEach {
                $0.yield(nil)
            }
            continuationMap.removeValue(forKey: key)
            memoryMap.removeValue(forKey: key)
            lock.unlock()
        },
        removeAll: {
            lock.lock()
            memoryMap.removeAll()
            continuationMap.values.forEach { continuations in
                continuations.values.forEach {
                    $0.yield(nil)
                }
            }
            continuationMap.removeAll()
            lock.unlock()
        }
    )
}
