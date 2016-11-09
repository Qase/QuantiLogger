//
//  FileManager.swift
//  QuantiLogger
//
//  Created by Martin Troup on 26.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation


/// LogFileManager manages all necessary operations for FileLogger.
public class FileLoggerManager {
    /// The class is used as a Singleton, thus should be accesed via instance property !!!
    public static let shared = FileLoggerManager()
    
    private(set) var logDirPath = NSTemporaryDirectory() {
        didSet {
            UserDefaults.standard.set(logDirPath, forKey: Constants.UserDefaultsKeys.logDirPath)
        }
    }
    private(set) var currentLogFileNumber: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentLogFileNumber, forKey: Constants.UserDefaultsKeys.currentLogFileNumber)
        }
    }
    private var dateOfLastLog: Date = Date() {
        didSet {
            UserDefaults.standard.set(dateOfLastLog, forKey: Constants.UserDefaultsKeys.dateOfLastLog)
        }
    }
    var numOfLogFiles: Int = 4 {
        willSet(newNumOfLogFiles) {
            if newNumOfLogFiles == 0 {
                preconditionFailure("There must be at least 1 log file so FileLogger can be used!")
            }
            if numOfLogFiles > newNumOfLogFiles {
                removeAllLogFiles()
            }
        }
        didSet {
            UserDefaults.standard.set(numOfLogFiles, forKey: Constants.UserDefaultsKeys.numOfLogFiles)
        }
    }
    
    private init() {
        if let _logDirPath = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.logDirPath) as? String {
            logDirPath = _logDirPath
        } else {
            UserDefaults.standard.set(logDirPath, forKey: Constants.UserDefaultsKeys.logDirPath)
        }
        if let _currentLogFileNumber = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.currentLogFileNumber) as? Int {
            currentLogFileNumber = _currentLogFileNumber
        } else {
            UserDefaults.standard.set(currentLogFileNumber, forKey: Constants.UserDefaultsKeys.currentLogFileNumber)
        }
    
        if let _dateOfLastLog = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.dateOfLastLog) as? Date {
            dateOfLastLog = _dateOfLastLog
        } else {
            UserDefaults.standard.set(dateOfLastLog, forKey: Constants.UserDefaultsKeys.dateOfLastLog)
        }
        
        if let _numOfLogFiles = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.numOfLogFiles) as? Int {
            numOfLogFiles = _numOfLogFiles
        } else {
            UserDefaults.standard.set(numOfLogFiles, forKey: Constants.UserDefaultsKeys.numOfLogFiles)
        }
    
        print("File log directory:", logDirPath)
    }
    
    
    /// Method to reset properties that control the correct flow of storing log files. 
    /// - "currentLogFileNumber" represents the current loging file number
    /// - "dateTimeOfLastLog" represents the last date the logger was used
    /// - "numOfLogFiles" represents the number of files that are used for loging, can be set by a user
    public func resetPropertiesToDefaultValues() {
        logDirPath = NSTemporaryDirectory()
        currentLogFileNumber = 0
        dateOfLastLog = Date()
        numOfLogFiles = 4
    }
    
    
    /// Method to get all log file names from dedicated log folder. These files are detected by its ".log" suffix.
    ///
    /// - Returns: Array of log file names
    func gettingAllLogFileNames() -> [String] {
        var logFileNames = [String]()
        let filesFromLogFir = FileManager.default.enumerator(atPath: logDirPath)
        while let file = filesFromLogFir?.nextObject() as? String {
            if file.hasSuffix("log") {
                logFileNames.append(file)
            }
        }
        return logFileNames
    }
    
    /// Method to remove all log files from dedicated log folder. These files are detected by its ".log" suffix.
    private func removeAllLogFiles() {
        for file in gettingAllLogFileNames() {
            removeLogFile(withName: file)
        }
    }
    
    /// Method to remove a specific log file from dedicated log folder.
    ///
    /// - Parameter fileName: fileName of the log file to be removed
    func removeLogFile(withName fileName: String) {
        let pathOfLogFileToDelete = "\(logDirPath)\(fileName)"
        
        let logFileToDeleteExists = (try? (URL(fileURLWithPath: pathOfLogFileToDelete, isDirectory: false)).checkResourceIsReachable()) ?? false
        if logFileToDeleteExists {
            do {
                try FileManager.default.removeItem(atPath: pathOfLogFileToDelete)
            } catch {
                //assertionFailure("Removing of \(pathOfLogFileToDelete) went wrong with error: \(error).")
            }
        }
    }
    
    
    /// Method to get String content of a specific log file from dedicated log folder.
    ///
    /// - Parameter fileName: fileName of the log file to be read from
    /// - Returns: content of the log file
    func readingContentFromLogFile(withName fileName: String) -> String? {
        let logFilePath = "\(logDirPath)\(fileName)"
        do {
            return try String(contentsOfFile: logFilePath, encoding: .utf8)
        } catch {
            //assertionFailure("Failed to read \(fileName)!")
        }
        return nil
    }
    
    /// Method to write a log message into the current log file.
    ///
    /// - Parameters:
    ///   - message: String loging message
    ///   - level: Level of the loging message
    func writeToLogFile(message: String, onLevel level: Level) {
        refreshCurrentLogFileStatus()
        
        let contentToAppend = "\(Constants.FileLogger.logFileRecordSeparator)\n[\(level.rawValue) \(Date().toFullDateTimeString())]\n\(message)\n\n"
        
        let pathOfCurrentLogFile = "\(logDirPath)\(currentLogFileNumber).log"
        
        //Check if file exists
        if let fileHandle = FileHandle(forWritingAtPath: pathOfCurrentLogFile) {
            //Append to file
            fileHandle.seekToEndOfFile()
            fileHandle.write(contentToAppend.data(using: .utf8)!)
        }
        else {
            //Create new file
            do {
                try contentToAppend.write(toFile: pathOfCurrentLogFile, atomically: true, encoding: .utf8)
            } catch let error {
                assertionFailure("Creating of \(pathOfCurrentLogFile) went wrong with error: \(error).")
            }
        }
    }
    
    /// Method to refresh/set "currentLogFileNumber" and "dateTimeOfLastLog" properties. It is called at the beginning 
    /// of writeToLogFile(_, _) method.
    private func refreshCurrentLogFileStatus() {
        let currentDate = Date()
        if currentDate.toFullDateString() != dateOfLastLog.toFullDateString() {
            currentLogFileNumber = (currentLogFileNumber + 1) % numOfLogFiles
            dateOfLastLog = currentDate
            
            removeLogFile(withName: "\(currentLogFileNumber).log")
        }
    }
    
    
    /// Method that parses a log file content into an array of LogFileRecord instances
    ///
    /// - Parameter fileName: fileName of a log file to parse
    /// - Returns: array of LogFileRecord instances
    func gettingRecordsFromLogFile(withName fileName: String) -> [LogFileRecord]? {
        let logFileContent = readingContentFromLogFile(withName: fileName)
        guard let _logFileContent = logFileContent else { return nil }
        
        var arrayOflogFileRecords = _logFileContent.components(separatedBy: Constants.FileLogger.logFileRecordSeparator)
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
