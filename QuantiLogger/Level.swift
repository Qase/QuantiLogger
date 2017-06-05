//
//  Levels.swift
//  QuantiLogger
//
//  Created by Martin Troup on 25.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation


/// Enum representing different possible levels for log messages.
public enum Level: String {
    case error = "ERROR"
    case warn = "WARNING"
    case info = "INFO"
    case debug = "DEBUG"
    case verbose = "VERBOSE"
    case system = "SYSTEM"
    case process = "PROCESS"
}
 
