//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 8/4/21.
//

import Foundation
import os.log

struct OSLogger: Logging {
    
    func log(_ message: String, file: String, function: String, line: Int) {
        os_log("%@", message)
    }
    
    func log(_ error: Error, file: String, function: String, line: Int) {
        os_log("%@", error.localizedDescription)
    }
}
