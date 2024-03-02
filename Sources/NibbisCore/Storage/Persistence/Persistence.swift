//
//  Persistence.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 12/26/23.
//

import Foundation
import SwiftData

public struct Persistence {
    
    public var start: () throws -> Void
    public var container: () throws -> ModelContainer
    public var backgroundModelActor: () -> BackgroundModelActor
    public var remoteChanges: @Sendable () async -> AsyncStream<Void>
    
    public init(
        start: @escaping () -> Void,
        container: @escaping () -> ModelContainer,
        backgroundModelActor: @escaping () -> BackgroundModelActor,
        remoteChanges: @escaping @Sendable () async -> AsyncStream<Void>
    ) {
        self.start = start
        self.container = container
        self.backgroundModelActor = backgroundModelActor
        self.remoteChanges = remoteChanges
    }
}

public actor BackgroundModelActor: ModelActor {
    
    public let modelContainer: ModelContainer
    public let modelExecutor: any ModelExecutor
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    public func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T] {
        try modelContext.fetch(descriptor)
    }
    
    public func insert(_ model: any PersistentModel) {
        modelContext.insert(model)
    }
    
    public func saveIfChanges() throws {
        try modelContext.saveIfChanges()
    }
    
    public func delete<T: PersistentModel>(_ model: T) {
        modelContext.delete(model)
    }
    
    public func delete<T: PersistentModel>(model: T.Type, where predicate: Predicate<T>? = nil, includeSubclasses: Bool = true) throws {
        try modelContext.delete(model: model, where: predicate, includeSubclasses: includeSubclasses)
    }
}

public extension ModelContext {
    
    func saveIfChanges() throws {
        if self.hasChanges {
            try self.save()
        }
    }
}
