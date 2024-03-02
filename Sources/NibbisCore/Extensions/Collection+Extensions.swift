//
//  Collection+Extensions.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 9/17/23.
//

import Foundation

public extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension MutableCollection {
    
    subscript(safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }
        set(newValue) {
            if let newValue = newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}
