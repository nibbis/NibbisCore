//
//  Int+Extensions.swift
//  NibbisCore
//
//  Created by Chesley Stephens on 9/27/23.
//

import Foundation

public extension Int {
    
    var degreesToRadians: Float {
        Float(self) * .pi / 180.0
    }
}
