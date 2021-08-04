//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/19/21.
//

import Foundation

public protocol PersistentContext {
    
    func queue<T>(operation: @escaping () throws -> T) async rethrows -> T
    func queueAndWait(operation: () -> Void)
}
