//
//  LoggingManager.swift
//  QuantiLogger
//
//  Created by Martin Troup on 25.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation

/// Global method that handles logging. Once the LogManager is set and all necessary loggers are registered somewhere
/// at the beginning of the application, this method can be called throughout the whole project in order to log.
///
/// - Parameters:
///   - message: String logging message
///   - level: Level of the logging message
public func QLog(_ message: String, onLevel level: Level, performAs loggingConcurrency: LoggingConcurrency? = nil) {
    LogManager.shared.log(message, onLevel: level, performAs: loggingConcurrency)
}

/// Logging concurrency types
///
/// - syncSerial: logging executed synchronously towards the main thread. All loggers log serially one by one within a dedicated queue
/// - asyncSerial: logging executed asynchronously towards the main thread. All loggers log serially one by one within a dedicated queue
/// - syncConcurrent: logging executed synchronously towards the main thread. All loggers log concurrently within a dedicated queue
public enum LoggingConcurrency {
	case syncSerial
	case asyncSerial
	case syncConcurrent
}

/// LogManager manages different types of loggers. The class enables to register custom or pre-built loggers.
/// Each of these logger classes must be subclassed from BaseLogger. The class handles logging to registered loggers
/// based on levels they are set to acccept.
public class LogManager {

    // The class is used as a Singleton, thus should be accesed via instance property !!!
    public static let shared = LogManager()

	public var loggingConcurrencyUsed: LoggingConcurrency = .asyncSerial

    private let serialLoggingQueue = DispatchQueue(label: "com.quanti.swift.QuantiLoggerSerial", qos: .background)
	private let concurrentLoggingQueue = DispatchQueue(label: "com.quanti.swift.QuantiLoggerConcurrent", qos: .background, attributes: .concurrent)

    private var loggers: [Logging]

    private init() {
        loggers = [Logging]()
    }

    /// Method to register a new custom or pre-build logger.
    ///
    /// - Parameter logger: Logger to be registered.
    public func add(_ logger: Logging) {
        logger.configure()
        loggers.append(logger)
    }

    /// Method to remove all existing loggers registered to the Log manager.
    public func removeAllLoggers() {
        loggers = [Logging]()
    }

	/// Method to handle logging, it is called internaly via global method QLog(_, _) and thus its not visible outside
	/// of the module.
	///
	/// - Parameters:
	///   - message: String logging message
	///   - level: Level of the logging message
	///   - loggingConcurrency: Logging concurrency type
	func log(_ message: String, onLevel level: Level, performAs loggingConcurrency: LoggingConcurrency? = nil) {
		let loggingConcurrentyToUse = loggingConcurrency ?? loggingConcurrencyUsed

		switch loggingConcurrentyToUse {
		case .syncSerial:
			logSyncSerially(message, onLevel: level)
		case .asyncSerial:
			logAsyncSerially(message, onLevel: level)
		case .syncConcurrent:
			logSyncConcurrently(message, onLevel: level)
		}
    }

	/// Method to log synchronously towards the main thread. All loggers log serially one by one within a dedicated queue.
	///
	/// - Parameters:
	///   - message: to be logged
	///   - level: of the message to be logged
	private func logSyncSerially(_ message: String, onLevel level: Level) {
		serialLoggingQueue.sync {
			guard self.loggers.count > 0 else {
				assertionFailure("No loggers were added to the LogManager.")
				return
			}

			self.loggers
				.filter { $0.doesLog(forLevel: level) }
				.forEach { $0.log(message, onLevel: level)}
		}
	}

	/// Method to log asynchronously towards the main thread. All loggers log serially one by one within a dedicated queue.
	///
	/// - Parameters:
	///   - message: to be logged
	///   - level: of the message to be logged
	private func logAsyncSerially(_ message: String, onLevel level: Level) {
		serialLoggingQueue.async {
			guard self.loggers.count > 0 else {
				assertionFailure("No loggers were added to the LogManager.")
				return
			}

			self.loggers
				.filter { $0.doesLog(forLevel: level) }
				.forEach { $0.log(message, onLevel: level)}
		}
	}

	/// Method to log synchronously towards the main thread. All loggers log concurrently within a dedicated queue.
	///
	/// - Parameters:
	///   - message: to be logged
	///   - level: of the message to be logged
	private func logSyncConcurrently(_ message: String, onLevel level: Level) {
		serialLoggingQueue.sync {
			guard loggers.count > 0 else {
				assertionFailure("No loggers were added to the LogManager.")
				return
			}
			self.loggers
				.filter { $0.doesLog(forLevel: level) }
				.forEach({ (logger) in
					concurrentLoggingQueue.async {
						logger.log(message, onLevel: level)
					}
				})
		}
	}

    /// !!! This method only serves for unit tests !!! Before checking values (XCT checks), unit tests must wait for loging jobs to complete.
    /// Loging is being executed on a different queue (logingQueue) and thus here the main queue waits (sync) until all of logingQueue jobs are completed.
    /// Then it executes the block within logingQueue.sync which is empty, so it continues on doing other things.
    func waitForLogingJobsToFinish() {
        serialLoggingQueue.sync {
            //
        }
    }

}
