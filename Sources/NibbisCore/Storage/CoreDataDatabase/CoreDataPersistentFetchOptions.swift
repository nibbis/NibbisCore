//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/20/21.
//

import Foundation

public struct CoreDataPersistentFetchOptions: PersistentFetchOptions {
    
    public let predicate: NSPredicate?
    public let sortDescriptors: [NSSortDescriptor]?
    
    public init(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }
}
