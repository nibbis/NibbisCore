//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 8/4/21.
//

import Foundation

public enum LoggerTypes {
    
    case os
}

public protocol Logging {
    
    func log(_ message: String, file: String, function: String, line: Int)
    func log(_ error: Error, file: String, function: String, line: Int)
}

public struct Logger: Logging {
    
    private var loggers: [Logging]
    
    public init(types: [LoggerTypes]) {
        loggers = [Logging]()
        
        types.forEach {
            switch $0 {
            case .os:
                let osLogger = OSLogger()
                loggers.append(osLogger)
            }
        }
    }
    
    public func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        loggers.forEach {
            $0.log(message, file: file, function: function, line: line)
        }
    }
    
    public func log(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
        loggers.forEach {
            $0.log(error, file: file, function: function, line: line)
        }
    }
}
