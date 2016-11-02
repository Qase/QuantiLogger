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
        LogFileManager.instance.resetPropertiesToDefaultValues()
        
        // Check if default values were propertly stored to UserDefaults
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
        LogFileManager.instance.resetPropertiesToDefaultValues()
        
        // Get the path of the first (1) log file - which is the first log file to write to after reseting properties to default values
        let logFilePath = "\(NSTemporaryDirectory())0.log"
        
        // Check if the file exists and if it does - remove it before its created within the test
        let logFileExists = (try? (URL(fileURLWithPath: logFilePath, isDirectory: false)).checkResourceIsReachable()) ?? false
        if logFileExists {
            do {
                try FileManager.default.removeItem(atPath: logFilePath)
            } catch {
                XCTFail("Failed to remove testing log file before the actual test!")
            }
        }
        
        // Set Console logger and File logger
        let logManager = LogManager.instance
        logManager.add(ConsoleLogger(withLevels: [.warn, .error]))
        logManager.add(FileLogger(withLevels: [.error, .info]))
        
        // Should be displayed in console + written to file
        QLog("Error message", onLevel: .error)
        // Should be displayed in console + NOT written to file
        QLog("Warning message", onLevel: .warn)
        // Should NOT be displayed in console + written to file
        QLog("Info message", onLevel: .info)
        
        // Check if logs were correctly written in the log file
        do {
            let contentOfLogFile = try String(contentsOfFile: logFilePath, encoding: .utf8)
            let linesOfContent = contentOfLogFile.components(separatedBy: .newlines)
            XCTAssertNotNil(linesOfContent[0].range(of: "^\\[ERROR \\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}]$", options: .regularExpression))
            XCTAssertNotNil(linesOfContent[1].range(of: "^Error message$", options: .regularExpression))
            XCTAssertEqual(linesOfContent[2], "")
            XCTAssertNotNil(linesOfContent[3].range(of: "^\\[INFO \\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}]$", options: .regularExpression))
            XCTAssertNotNil(linesOfContent[4].range(of: "^Info message$", options: .regularExpression))
        } catch {
            XCTFail("Failed to read testing log file!")
        }
        
        // Remove the log file
        do {
            try FileManager.default.removeItem(atPath: logFilePath)
        } catch {
            XCTFail("Failed to remove testing log file, it should be deleted manualy.")
        }
    }
}
