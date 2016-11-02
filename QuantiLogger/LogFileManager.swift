//
//  FileManager.swift
//  QuantiLogger
//
//  Created by Martin Troup on 26.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation


/// LogFileManager manages all necessary operations for FileLogger.
class LogFileManager {
    /// The class is used as a Singleton, thus should be accesed via instance property !!!
    static let instance = LogFileManager()
    
    // NOTE: NSTemoporaryDirectory() should return always the same directory -> if that is not true, it might cause problems and then
    // it should be stored and restored from UserDefaults as other properties are.
    let logDirPath = NSTemporaryDirectory()//URL(string: NSTemporaryDirectory())!
    private var currentLogFileNumber: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentLogFileNumber, forKey: Constants.UserDefaultsKeys.currentLogFileNumber)
            UserDefaults.standard.synchronize()
        }
    }
    private var dateOfLastLog: Date = Date() {
        didSet {
            UserDefaults.standard.set(dateOfLastLog, forKey: Constants.UserDefaultsKeys.dateOfLastLog)
            UserDefaults.standard.synchronize()
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
            UserDefaults.standard.synchronize()
        }
    }
    
    private init() {
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
    
        UserDefaults.standard.synchronize()
        print("File log directory:", logDirPath)
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
        let files = FileManager.default.enumerator(atPath: logDirPath)
        while let file = files?.nextObject() as? String {
            if file.hasSuffix("log") {
                removeLogFile(withFileName: file)
            }
        }
    }
    
    /// Method to remove a specific log file (by its name given as a paramter) from dedicated log folder.
    private func removeLogFile(withFileName fileName: String) {
        let pathOfLogFileToDelete = "\(logDirPath)\(fileName)"
        
        let logFileToDeleteExists = (try? (URL(fileURLWithPath: pathOfLogFileToDelete, isDirectory: false)).checkResourceIsReachable()) ?? false
        if logFileToDeleteExists {
            do {
                try FileManager.default.removeItem(atPath: pathOfLogFileToDelete)
            } catch let error {
                print("Removing of \(pathOfLogFileToDelete) went wrong with error: \(error).")
            }
        }
    }
    
    
    /// Method to write a log message into the current log file.
    ///
    /// - Parameters:
    ///   - message: String loging message
    ///   - level: Level of the loging message
    func writeToLogFile(message: String, onLevel level: Level) {
        refreshCurrentLogFileStatus()
        
        let contentToAppend = "[\(level.rawValue) \(Date().toFullDateTimeString())]\n\(message)\n\n"
        
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
                print("Creating of \(pathOfCurrentLogFile) went wrong with error: \(error).")
            }
        }
    }
    
    /// Method to refresh/set "currentLogFileNumber" and "dateTimeOfLastLog" properties. It is called at the beginning 
    /// of writeToLogFile(_, _) method.
    private func refreshCurrentLogFileStatus() {
        let currentDate = Date()
        if currentDate.toFullDateTimeString() != dateOfLastLog.toFullDateTimeString() {
            currentLogFileNumber = (currentLogFileNumber + 1) % numOfLogFiles
            dateOfLastLog = currentDate
            
            removeLogFile(withFileName: "\(currentLogFileNumber).log")
        }
    }
    
}
