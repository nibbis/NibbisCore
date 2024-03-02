//
//  Queue.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 2/21/23.
//

import Foundation

public final class Queue<T> {
    
    @Atomic private var elements: [T] = []
    
    public init() { }
    
    public var isEmpty: Bool {
        elements.isEmpty
    }
    
    public var peek: T? {
        elements.first
    }
    
    public var peekAll: [T] {
        elements
    }
    
    public func enqueue(_ value: T) {
        elements.append(value)
    }
    
    public func enqueue(_ value: [T]) {
        elements.append(contentsOf: value)
    }
    
    public func dequeue() -> T? {
        isEmpty ? nil: elements.removeFirst()
    }
    
    public func dequeueAll() -> [T] {
        let elements = elements
        self.elements.removeAll()
        return elements
    }
}
