//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/21/21.
//

import CoreData
import Foundation

class CoreDataPersistentObserver<T: PersistentModel>: NSObject, NSFetchedResultsControllerDelegate, PersistentObserver {
    
    private let context: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    private var lastFetched = [T]()
    private var currentDiff = CollectionDifference<T>([])
    
    private var continuation: AsyncStream<CollectionDifference<T>>.Continuation?
    
    required init(
        context: NSManagedObjectContext,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]
    ) {
        self.context = context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))

        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }

        fetchRequest.sortDescriptors = sortDescriptors
        
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()

        self.fetchedResultsController.delegate = self
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        context.perform { [weak self] in
            self?.updateDiff()
        }
    }
    
    func observe() -> AsyncStream<CollectionDifference<T>> {
        AsyncStream<CollectionDifference<T>> { [weak self] continuation in
            self?.continuation = continuation
            
            self?.context.perform { [weak self] in
                do {
                    try self?.fetchedResultsController.performFetch()
                    self?.updateDiff()
                } catch {
                    fatalError()
                }
            }
        }
    }
    
    func updateDiff() {
        let fetchedObjects = fetchedResultsController.fetchedObjects as? [T] ?? []
        let difference = fetchedObjects.difference(from: lastFetched)
        lastFetched = fetchedObjects
        continuation?.yield(difference)
    }
}
