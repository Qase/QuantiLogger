//
//  Constants.swift
//  QuantiLogger
//
//  Created by Martin Troup on 01.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation

struct Constants {
    
    struct UserDefaultsKeys {
        static let logDirPath = "logDirPath"
        static let currentLogFileNumber = "currentLogFileNumber"
        static let dateOfLastLog = "dateOfLastLog"
        static let numOfLogFiles = "numOfLogFiles"
    }
    
    struct FileLogger {
        static let logRecordSeparator = "<-- QLog -->"
    }
}
