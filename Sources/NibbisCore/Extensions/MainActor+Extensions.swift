//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/28/21.
//

import Foundation

extension MainActor {
    
    public static func run<T>(resultType: T.Type = T.self, body: @MainActor @Sendable () throws -> T) async rethrows -> T {
        try await body()
    }
}
