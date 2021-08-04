//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/19/21.
//

import CoreData
import Foundation

public struct CoreDataPersistentDatabase {
    
    public var newBackgroundContext: PersistentContext {
        container.newBackgroundContext()
    }
    
    public var viewContext: PersistentContext {
        container.viewContext
    }
    
    let container: NSPersistentContainer
    
    private let inMemory: Bool
    
    public init(name: String, inMemory: Bool, useCloudKit: Bool) {
        self.inMemory = inMemory
        
        if useCloudKit {
            container = NSPersistentCloudKitContainer(name: name)
        } else {
            container = NSPersistentContainer(name: name)
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public func loadPersistentStores(completion: (() -> Void)?) {
        if let storeDescription = container.persistentStoreDescriptions.first {
            storeDescription.shouldAddStoreAsynchronously = true
            
            if inMemory {
                storeDescription.url = URL(fileURLWithPath: "/dev/null")
                storeDescription.shouldAddStoreAsynchronously = false
            }
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            completion?()
        })
    }
}

extension CoreDataPersistentDatabase: PersistentDatabase {
    
    public func create<T: PersistentModel>(context: PersistentContext) -> T {
        T.create(context: context)
    }
    
    public func makeObserver<T: PersistentModel>(context: PersistentContext, options: PersistentFetchOptions?) -> AnyPersistentObserver<T> {
        T.makeObserver(context: context, options: options)
    }
    
    public func fetch<T: PersistentModel>(context: PersistentContext, options: PersistentFetchOptions?) throws -> AnyCollection<T> {
        try T.fetch(context: context, options: options)
    }
    
    public func save(context: PersistentContext) throws {
        guard let context = context as? NSManagedObjectContext else {
            fatalError()
        }
        if context.hasChanges {
            try context.save()
        }
    }
    
    public func delete<T: PersistentModel>(model: T, context: PersistentContext) {
       model.delete(context: context)
    }
    
    public func deleteAll<T: PersistentModel>(model: T.Type, context: PersistentContext) throws {
        guard let context = context as? NSManagedObjectContext else {
            fatalError()
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: T.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try container.persistentStoreCoordinator.execute(deleteRequest, with: context)
    }
}
