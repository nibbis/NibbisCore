//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/19/21.
//

import Foundation

public protocol PersistentDatabase {
    
    var newBackgroundContext: PersistentContext { get }
    var viewContext: PersistentContext { get }
    
    func loadPersistentStores(completion: (() -> Void)?)
    
    func create<T: PersistentModel>(context: PersistentContext) -> T
    func makeObserver<T: PersistentModel>(context: PersistentContext, options: PersistentFetchOptions?) -> AnyPersistentObserver<T>
    func fetch<T: PersistentModel>(context: PersistentContext, options: PersistentFetchOptions?) throws -> AnyCollection<T>
    func save(context: PersistentContext) throws
    func delete<T: PersistentModel>(model: T, context: PersistentContext)
    func deleteAll<T: PersistentModel>(model: T.Type, context: PersistentContext) throws
}
