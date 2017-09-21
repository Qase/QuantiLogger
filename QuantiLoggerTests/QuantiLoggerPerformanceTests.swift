//
//  QuantiLoggerPerformanceTests.swift
//  QuantiLogger
//
//  Created by Jakub Prusa on 21.08.17.
//  Copyright © 2017 quanti. All rights reserved.
//

import XCTest
@testable import QuantiLogger

// Custom logger for performance testing
class PerformanceLogger: QuantiLogger.Logging {
    open func configure() {
        //
    }
    open func log(_ message: String, onLevel level: Level) {
        sleep(1)
    }

    open func levels() -> [Level] {
        return [.verbose, .info, .debug, .warn, .error]
    }

}

class QuantiLoggerPerformanceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // Set Console logger and File logger
        let logManager = LogManager.shared
        logManager.removeAllLoggers()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDirectLog() {

        let performanceLogger = PerformanceLogger()
        LogManager.shared.add(performanceLogger)

        // This code log directly into logger, where is sleep for 1 second
        // So total run time should be 1s
        self.measure {
            // Put the code you want to measure the time of here.
            performanceLogger.log("Test", onLevel: .info)
        }
    }

    func testOuterLog() {

        let performanceLogger = PerformanceLogger()
        LogManager.shared.add(performanceLogger)

        // This code use QLog wrapper over performance logger.
        // So work should be dispatch in special queue without blocking current thread
        self.measure {
            // Put the code you want to measure the time of here.
            QLog("Test", onLevel: .info)
        }

        LogManager.shared.waitForLogingJobsToFinish()
    }
    

    func testThousandRunNSLog() {
        let performanceLogger = PerformanceLogger()
        LogManager.shared.add(performanceLogger)

        self.measure {
            for _ in 1...1000 {
                NSLog("Test")
            }
        }
    }

    func testThousandRunPrint() {
        let performanceLogger = PerformanceLogger()
        LogManager.shared.add(performanceLogger)

        self.measure {
            for _ in 1...1000 {
                print("Test")
            }
        }
    }

    func testThousandRunQLogConsoleAsync() {
        let consoleLogger = ConsoleLogger()
        consoleLogger.levels = [.info]
        LogManager.shared.add(consoleLogger)

        self.measure {
            for _ in 1...1000 {
                QLog("Test", onLevel: .info)
            }
        }

        LogManager.shared.waitForLogingJobsToFinish()
    }

    func testThousandRunQLogFileAsync() {
        let fileLogger = FileLogger()
        fileLogger.levels = [.info]
        LogManager.shared.add(fileLogger)

        self.measure {
            for _ in 1...1000 {
                QLog("Test", onLevel: .info)
            }
        }

        LogManager.shared.waitForLogingJobsToFinish()
    }

    func testThousandRunQLogBothAsync() {
        let fileLogger = FileLogger()
        fileLogger.levels = [.info]
        LogManager.shared.add(fileLogger)

        let consoleLogger = ConsoleLogger()
        consoleLogger.levels = [.info]
        LogManager.shared.add(consoleLogger)

        self.measure {
            for _ in 1...1000 {
                QLog("Test", onLevel: .info)
            }
        }

        LogManager.shared.waitForLogingJobsToFinish()
    }

    func testThousandRunQLogConsoleSync() {
        let consoleLogger = ConsoleLogger()
        consoleLogger.levels = [.info]
        LogManager.shared.add(consoleLogger)

        self.measure {
            for _ in 1...1000 {
                QLog("Test", onLevel: .info, performAsync: false)
            }
        }
    }

    func testThousandRunQLogFileSync() {
        let fileLogger = FileLogger()
        fileLogger.levels = [.info]
        LogManager.shared.add(fileLogger)

        self.measure {
            for _ in 1...1000 {
                QLog("Test", onLevel: .info, performAsync: false)
            }
        }
    }

    func testThousandRunQLogBothSync() {
        let fileLogger = FileLogger()
        fileLogger.levels = [.info]
        LogManager.shared.add(fileLogger)

        let consoleLogger = ConsoleLogger()
        consoleLogger.levels = [.info]
        LogManager.shared.add(consoleLogger)

        self.measure {
            for _ in 1...1000 {
                QLog("Test", onLevel: .info, performAsync: false)
            }
        }
    }
        
}
