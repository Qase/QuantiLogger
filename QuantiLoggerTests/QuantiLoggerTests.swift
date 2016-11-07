//
//  QuantiLoggerTests.swift
//  QuantiLoggerTests
//
//  Created by Martin Troup on 25.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import XCTest
@testable import QuantiLogger

class QuantiLoggerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInicializationOfFileLogger() {
        // Set default values for all Logger properties and store them to UserDefaults
        LogFileManager.shared.resetPropertiesToDefaultValues()
        
        // Check if default values were propertly stored to UserDefaults
        if let _logDirPath = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.logDirPath) as? String {
            XCTAssertNotNil(_logDirPath.range(of: "^/.*/$", options: .regularExpression))
        } else {
            XCTFail()
        }
        
        if let _currentLogFileNumber = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.currentLogFileNumber) as? Int {
            XCTAssertEqual(0, _currentLogFileNumber)
        } else {
            XCTFail()
        }
        
        if let _dateTimeOfLastLog = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.dateOfLastLog) as? Date {
            XCTAssertNotNil(_dateTimeOfLastLog.toFullDateString().range(of: "^\\d{4}-\\d{2}-\\d{2}$", options: .regularExpression))
        } else {
            XCTFail()
        }
        
        if let _numOfLogFiles = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.numOfLogFiles) as? Int {
            XCTAssertEqual(4, _numOfLogFiles)
        } else {
            XCTFail()
        }
    }
    
    func testLogger() {
        LogFileManager.shared.resetPropertiesToDefaultValues()
        
        // Get the path of the first (0) log file - which is the first log file to write to after reseting properties to default values
        let testLogFileName = "0.log"
        
        // Check if the file exists and if it does - remove it before its created within the test
        LogFileManager.shared.removeLogFile(withName: testLogFileName)
        
        // Set Console logger and File logger
        let logManager = LogManager.shared
        
        let consoleLogger = ConsoleLogger()
        consoleLogger.levels = [.warn, .error]
        logManager.add(consoleLogger)
        
        let fileLogger = FileLogger()
        fileLogger.levels = [.error, .info]
        logManager.add(fileLogger)
        
        // Should be displayed in console + written to file
        QLog("Error message", onLevel: .error)
        // Should be displayed in console + NOT written to file
        QLog("Warning message", onLevel: .warn)
        // Should NOT be displayed in console + written to file
        QLog("Info message", onLevel: .info)
        
        // Check if logs were correctly written in the log file
        let contentOfLogFile = LogFileManager.shared.readingContentFromLogFile(withName: testLogFileName)
        
        guard let _contentOfLogFile = contentOfLogFile else {
            XCTFail("Log file is empty even though it should not be!")
            return
        }
        
        let linesOfContent = _contentOfLogFile.components(separatedBy: .newlines)
        XCTAssertEqual(Constants.FileLogger.logRecordSeparator, linesOfContent[0])
        XCTAssertNotNil(linesOfContent[1].range(of: "^\\[ERROR \\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}]$", options: .regularExpression))
        XCTAssertNotNil(linesOfContent[2].range(of: "^Error message$", options: .regularExpression))
        XCTAssertEqual(linesOfContent[3], "")
        XCTAssertEqual(Constants.FileLogger.logRecordSeparator, linesOfContent[4])
        XCTAssertNotNil(linesOfContent[5].range(of: "^\\[INFO \\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}]$", options: .regularExpression))
        XCTAssertNotNil(linesOfContent[6].range(of: "^Info message$", options: .regularExpression))
    
        
        // Remove the log file
        LogFileManager.shared.removeLogFile(withName: testLogFileName)
    }
    
}
