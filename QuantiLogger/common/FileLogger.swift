//
//  FileLogger.swift
//  QuantiLogger
//
//  Created by Martin Troup on 26.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation

/// Pre-built logger that logs to a single or multiple files within dedicated log dir.
public class FileLogger: Logging {
    private let fileLoggerManager: FileLoggerManager

    /// Property to set a number of log files that can be used for loging.
    public var numOfLogFiles: Int = 4 {
        didSet {
            fileLoggerManager.numOfLogFiles = numOfLogFiles
        }
    }

    // Url of the zip file containing all log files.
    public var archivedLogFilesUrl: URL? {
        fileLoggerManager.archivedLogFilesUrl
    }

    public var archivedLogFiles: Archive? {
        fileLoggerManager.archivedLogFiles
    }

	public var levels: [Level] = [.info]

    /// FileLogger initializer
    ///
    /// - Parameters:
    ///   - subsystem: suit name of the application. Must be passed to create logs from app extensions.
	public init(suiteName: String? = nil) {
        fileLoggerManager = FileLoggerManager(suiteName: suiteName)
    }

    public func log(_ message: String, onLevel level: Level) {
        fileLoggerManager.writeToLogFile(message: message, withMessageHeader: messageHeader(forLevel: level), onLevel: level)
    }

    public func logExt(_ message: String, onLevel level: Level) {
        fileLoggerManager.writeToExtensionLogFile(message: message, withMessageHeader: messageHeader(forLevel: level), onLevel: level)
    }

	public func deleteAllLogFiles() {
		fileLoggerManager.deleteAllLogFiles()
	}

}
