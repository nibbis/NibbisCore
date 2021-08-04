//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 8/3/21.
//

import Foundation

public protocol PersistentObserver {
    
    associatedtype PersistentModel
    
    func observe() -> AsyncStream<CollectionDifference<PersistentModel>>
}

public class AnyPersistentObserver<PersistentModel>: PersistentObserver {
    
    private let observeObject: () -> AsyncStream<CollectionDifference<PersistentModel>>

    public init<T: PersistentObserver>(_ wrappedObserver: T) where T.PersistentModel == PersistentModel {
        self.observeObject = wrappedObserver.observe
    }
    
    public func observe() -> AsyncStream<CollectionDifference<PersistentModel>> {
        observeObject()
    }
}
