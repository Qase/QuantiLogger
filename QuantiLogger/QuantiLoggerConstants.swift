//
//  Constants.swift
//  QuantiLogger
//
//  Created by Martin Troup on 01.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation

public struct QuantiLoggerConstants {
    
    struct UserDefaultsKeys {
        static let logDirUrl = "logDirUrl"
        static let currentLogFileNumber = "currentLogFileNumber"
        static let dateOfLastLog = "dateOfLastLog"
        static let numOfLogFiles = "numOfLogFiles"
    }
    
    struct FileLogger {
        static let logFileRecordSeparator = "<-- QLog -->"
    }
    
    public struct FileLoggerTableViewDatasource {
        public static let fileLoggerTableViewCellIdentifier = "fileLoggerTableViewCellIdentifier"
    }
}
