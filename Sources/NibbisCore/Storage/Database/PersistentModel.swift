//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/19/21.
//

import Foundation

public protocol PersistentModel: Equatable {
    
    static func create(context: PersistentContext) -> Self
    static func fetch(context: PersistentContext, options: PersistentFetchOptions?) throws -> AnyCollection<Self>
    static func makeObserver(context: PersistentContext, options: PersistentFetchOptions?) -> AnyPersistentObserver<Self>
    func delete(context: PersistentContext)
}
