//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/19/21.
//

import Foundation

public extension LocalStorage {
    
    static func memory() -> Self {
        
        let queue = DispatchQueue(label: "MemoryLocalStorageQueue", attributes: .concurrent)
        var observe: ((_ oldValue: [String: AnyHashable], _ newValue: [String: AnyHashable]) -> Void)?
        
        var memory = [String: AnyHashable]() {
            didSet {
                observe?(oldValue, memory)
            }
        }
        
        return Self(
            save: { key, value in
                queue.async(flags: .barrier) {
                    memory[key] = value
                }
            },
            get: { key in
                queue.sync {
                    memory[key]
                }
            },
            observe: { key in
                AsyncStream<AnyHashable?> { continuation in
                    continuation.yield(memory[key])
                    
                    observe = { oldValue, newValue in
                        if oldValue[key] != memory[key] {
                            continuation.yield(memory[key])
                        }
                    }
                }
            },
            remove: { key in
                queue.async(flags: .barrier) {
                    memory.removeValue(forKey: key)
                }
            },
            removeAll: {
                queue.async(flags: .barrier) {
                    memory.removeAll()
                }
            }
        )
    }
}
