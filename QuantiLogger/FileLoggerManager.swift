//
//  FileManager.swift
//  QuantiLogger
//
//  Created by Martin Troup on 26.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation


/// LogFileManager manages all necessary operations for FileLogger.
class FileLoggerManager {
    /// The class is used as a Singleton, thus should be accesed via instance property !!!
    static let shared = FileLoggerManager()
    
    private(set) var logDirUrl: URL?
    
    private(set) var currentLogFileNumber: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentLogFileNumber, forKey: QuantiLoggerConstants.UserDefaultsKeys.currentLogFileNumber)
        }
    }
    private var dateOfLastLog: Date = Date() {
        didSet {
            UserDefaults.standard.set(dateOfLastLog, forKey: QuantiLoggerConstants.UserDefaultsKeys.dateOfLastLog)
        }
    }
    var numOfLogFiles: Int = 4 {
        willSet(newNumOfLogFiles) {
            if newNumOfLogFiles == 0 {
                preconditionFailure("There must be at least 1 log file so FileLogger can be used.")
            }
            if numOfLogFiles > newNumOfLogFiles {
                removeAllLogFiles()
            }
        }
        didSet {
            UserDefaults.standard.set(numOfLogFiles, forKey: QuantiLoggerConstants.UserDefaultsKeys.numOfLogFiles)
        }
    }
    
    private init() {
        do {
            let fileManager = FileManager.default
            let documentDirUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let _logDirUrl = documentDirUrl.appendingPathComponent("logs")
            if !fileManager.fileExists(atPath: _logDirUrl.path) {
                try fileManager.createDirectory(at: _logDirUrl, withIntermediateDirectories: true, attributes: nil)
            }
            logDirUrl = _logDirUrl
        } catch let error {
            assertionFailure("Failed to create log directory with error: \(error).")
        }
        
        if let _currentLogFileNumber = UserDefaults.standard.object(forKey: QuantiLoggerConstants.UserDefaultsKeys.currentLogFileNumber) as? Int {
            currentLogFileNumber = _currentLogFileNumber
        } else {
            UserDefaults.standard.set(currentLogFileNumber, forKey: QuantiLoggerConstants.UserDefaultsKeys.currentLogFileNumber)
        }
    
        if let _dateOfLastLog = UserDefaults.standard.object(forKey: QuantiLoggerConstants.UserDefaultsKeys.dateOfLastLog) as? Date {
            dateOfLastLog = _dateOfLastLog
        } else {
            UserDefaults.standard.set(dateOfLastLog, forKey: QuantiLoggerConstants.UserDefaultsKeys.dateOfLastLog)
        }
        
        if let _numOfLogFiles = UserDefaults.standard.object(forKey: QuantiLoggerConstants.UserDefaultsKeys.numOfLogFiles) as? Int {
            numOfLogFiles = _numOfLogFiles
        } else {
            UserDefaults.standard.set(numOfLogFiles, forKey: QuantiLoggerConstants.UserDefaultsKeys.numOfLogFiles)
        }
        
        guard let _logDirPath = logDirUrl else {
            assertionFailure("Log directory was not set properly.")
            return
        }
        print("File log directory: \(_logDirPath)")
    }
    
    
    /// Method to reset properties that control the correct flow of storing log files. 
    /// - "currentLogFileNumber" represents the current loging file number
    /// - "dateTimeOfLastLog" represents the last date the logger was used
    /// - "numOfLogFiles" represents the number of files that are used for loging, can be set by a user
    func resetPropertiesToDefaultValues() {
        currentLogFileNumber = 0
        dateOfLastLog = Date()
        numOfLogFiles = 4
    }
    
    
    /// Method to remove all log files from dedicated log folder. These files are detected by its ".log" suffix.
    private func removeAllLogFiles() {
        guard let _logFiles = gettingAllLogFiles() else { return }
        
        for logFileURL in _logFiles {
            removeLogFile(at: logFileURL)
        }
    }
    
    
    /// Method to get all log file names from dedicated log folder. These files are detected by its ".log" suffix.
    ///
    /// - Returns: Array of log file names
    func gettingAllLogFiles() -> [URL]? {
        guard let _logDirUrl = logDirUrl else { return nil }
        
        do {
            let directoryContent = try FileManager.default.contentsOfDirectory(at: _logDirUrl, includingPropertiesForKeys: nil, options: [])
            let logFiles = directoryContent.filter({ (file) -> Bool in
                file.pathExtension == "log"
            })
            
            return logFiles
        } catch let error {
            assertionFailure("Failed to get log directory content with error: \(error)")
        }
        
        return nil
    }
    
    
    /// Method to remove a specific log file from dedicated log folder.
    ///
    /// - Parameter fileName: fileName of the log file to be removed
    func removeLogFile(at fileUrlToDelete: URL) {
        if FileManager.default.fileExists(atPath: fileUrlToDelete.path) {
            do {
                try FileManager.default.removeItem(at: fileUrlToDelete)
            } catch {
                assertionFailure("Failed to remove log file with error: \(error)")
            }
        }
    }
    
    
    /// Method to get String content of a specific log file from dedicated log folder.
    ///
    /// - Parameter fileName: fileName of the log file to be read from
    /// - Returns: content of the log file
    func readingContentFromLogFile(at fileUrlToRead: URL) -> String? {
        if FileManager.default.fileExists(atPath: fileUrlToRead.path) {
            do {
                return try String(contentsOf: fileUrlToRead, encoding: .utf8)
            } catch let error {
                assertionFailure("Failed to read \(fileUrlToRead.path) with error: \(error)")
            }
        }
        return nil
    }
    
    /// Method to write a log message into the current log file.
    ///
    /// - Parameters:
    ///   - message: String loging message
    ///   - level: Level of the loging message
    func writeToLogFile(message: String, onLevel level: Level) {
        guard let _logDirUrl = logDirUrl else { return }
        
        refreshCurrentLogFileStatus()
        
        let contentToAppend = "\(QuantiLoggerConstants.FileLogger.logFileRecordSeparator)\n[\(level.rawValue) \(Date().toFullDateTimeString())]\n\(message)\n\n"
        
        let currentLogFileUrl = _logDirUrl.appendingPathComponent("\(currentLogFileNumber)").appendingPathExtension("log")
        do {
            if FileManager.default.fileExists(atPath: currentLogFileUrl.path) {
                let fileHandle = try FileHandle(forWritingTo: currentLogFileUrl)
                fileHandle.seekToEndOfFile()
                if let dataToAppend = contentToAppend.data(using: .utf8) {
                    fileHandle.write(dataToAppend)
                }
            } else {
                try contentToAppend.write(to: currentLogFileUrl, atomically: true, encoding: .utf8)
            }
        } catch let error {
            assertionFailure("Failed to write to log file with error: \(error)")
        }
    }
    
    /// Method to refresh/set "currentLogFileNumber" and "dateTimeOfLastLog" properties. It is called at the beginning 
    /// of writeToLogFile(_, _) method.
    private func refreshCurrentLogFileStatus() {
        guard let _logDirUrl = logDirUrl else { return }
        
        let currentDate = Date()
        if currentDate.toFullDateString() != dateOfLastLog.toFullDateString() {
            currentLogFileNumber = (currentLogFileNumber + 1) % numOfLogFiles
            dateOfLastLog = currentDate
            
            let currentLogFile = _logDirUrl.appendingPathComponent("\(currentLogFileNumber)").appendingPathExtension("log")
            removeLogFile(at: currentLogFile)
        }
    }
    
    
    /// Method that parses a log file content into an array of LogFileRecord instances
    ///
    /// - Parameter fileName: fileName of a log file to parse
    /// - Returns: array of LogFileRecord instances
    func gettingRecordsFromLogFile(at fileUrlToRead: URL) -> [LogFileRecord]? {
        let logFileContent = readingContentFromLogFile(at: fileUrlToRead)
        guard let _logFileContent = logFileContent else { return nil }
        
        var arrayOflogFileRecords = _logFileContent.components(separatedBy: QuantiLoggerConstants.FileLogger.logFileRecordSeparator)
        arrayOflogFileRecords.remove(at: 0)
        let logFileRecords = arrayOflogFileRecords.map { (logFileRecordInString) -> LogFileRecord in
            let trimmedLogFileRecordInString = logFileRecordInString.trimmingCharacters(in: .newlines)
            var arrayOfLogFileRecordLines = trimmedLogFileRecordInString.components(separatedBy: .newlines)
            
            let header = arrayOfLogFileRecordLines[0]
            arrayOfLogFileRecordLines.remove(at: 0)
            let body = arrayOfLogFileRecordLines.reduce("", { (logBody, logBodyLine) -> String in
                "\(logBody)\(logBodyLine)\n"
            })
            return LogFileRecord(header: header, body: body)
        }
    
        return logFileRecords
    }
}
