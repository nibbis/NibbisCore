//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/21/21.
//

import CoreData
import Foundation

extension NSManagedObjectContext: PersistentContext {
    
    public func queue<T>(operation: @escaping () throws -> T) async rethrows -> T {
        try await perform { try operation() }
    }
    
    public func queueAndWait(operation: () -> Void) {
        performAndWait { operation() }
    }
}
