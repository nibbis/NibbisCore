//
//  Set+Extensions.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 10/8/23.
//

import Foundation

public extension Set {
    
    func setMap<U>(transform: (Element) -> U) -> Set<U> {
        Set<U>(self.lazy.map(transform))
    }
}
