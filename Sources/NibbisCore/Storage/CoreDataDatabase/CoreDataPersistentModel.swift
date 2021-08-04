//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/20/21.
//

import CoreData
import Foundation

public extension PersistentModel where Self: NSManagedObject {
    
    static func create(context: PersistentContext) -> Self {
        guard let context = context as? NSManagedObjectContext else {
            fatalError()
        }
        
        return Self(context: context)
    }
    
    static func fetch(context: PersistentContext, options: PersistentFetchOptions?) throws -> AnyCollection<Self> {
        guard let context = context as? NSManagedObjectContext else {
            fatalError()
        }
        
        let options = options as? CoreDataPersistentFetchOptions
        
        let fetchRequest = NSFetchRequest<Self>(entityName: String(describing: self))
        
        if let predicate = options?.predicate {
            fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = options?.sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        let results = try context.fetch(fetchRequest)
        return AnyCollection(results)
    }
    
    static func makeObserver(context: PersistentContext, options: PersistentFetchOptions?) -> AnyPersistentObserver<Self> {
        guard let context = context as? NSManagedObjectContext else {
            fatalError()
        }
        
        let options = options as? CoreDataPersistentFetchOptions
        
        return AnyPersistentObserver(
            CoreDataPersistentObserver<Self> (
                context: context,
                predicate: options?.predicate,
                sortDescriptors: options?.sortDescriptors ?? []
            )
        )
    }
    
    func delete(context: PersistentContext) {
        guard let context = context as? NSManagedObjectContext else {
            fatalError()
        }
        
        context.delete(self)
    }
}
