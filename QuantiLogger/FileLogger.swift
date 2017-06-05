//
//  FileLogger.swift
//  QuantiLogger
//
//  Created by Martin Troup on 26.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation


/// Pre-built logger that logs to a single or multiple files within dedicated log dir.
public class FileLogger: InternalBaseLogger, Logging {
    
    public func levels() -> [Level] {
        return levels
    }

    public func log(_ message: String, onLevel level: Level) {
        FileLoggerManager.shared.writeToLogFile(message: message, withMessageHeader: messageHeader(forLevel: level), onLevel: level)
    }
    
    /// Method that enables to set a number of log files that can be used for logging.
    ///
    /// - Parameter number: Number of files
    public func set(numOfLogfiles number: Int) {
        FileLoggerManager.shared.numOfLogFiles = number
    }
    
    
}
