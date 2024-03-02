//
//  LocalStorage.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 7/13/21.
//

import Foundation

public struct LocalStorage {
    
    public var save: (_ key: String, _ value: AnyHashable) -> Void
    public var get: (_ key: String) -> AnyHashable?
    public var observe: (_ key: String) -> AsyncStream<AnyHashable?>
    public var remove: (_ key: String) -> Void
    public var removeAll: () -> Void
}
