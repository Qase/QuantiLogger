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
public func QLog(_ message: String, onLevel level: Level, performAsync async: Bool = true) {
    LogManager.shared.log(message, onLevel: level, performAsync: async)
}

/// LogManager manages different types of loggers. The class enables to register custom or pre-built loggers.
/// Each of these logger classes must be subclassed from BaseLogger. The class handles logging to registered loggers
/// based on levels they are set to acccept.
public class LogManager {

    // The class is used as a Singleton, thus should be accesed via instance property !!!
    public static let shared = LogManager()

	public var shouldPerformAsync = true

    private let logingQueue = DispatchQueue(label: "com.quanti.swift.QuantiLogger", qos: .background)

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
    func log(_ message: String, onLevel level: Level, performAsync: Bool) {
        // Dispatch loging on custom queue so it does not block the main queue

        func internalLog(_ message: String, onLevel level: Level) {
            if self.loggers.count == 0 {
                assertionFailure("No loggers were added to the manager.")
                return
            }

            for logger in self.loggers {
                if logger.doesLog(forLevel: level) {
                    logger.log(message, onLevel: level)
                }
            }
        }

		guard shouldPerformAsync else {
			logingQueue.sync {
				internalLog(message, onLevel: level)
			}

			return
		}

		if performAsync {
            logingQueue.async {
                internalLog(message, onLevel: level)
            }
        } else {
            logingQueue.sync {
                internalLog(message, onLevel: level)
            }
        }
    }

    /// !!! This method only serves for unit tests !!! Before checking values (XCT checks), unit tests must wait for loging jobs to complete.
    /// Loging is being executed on a different queue (logingQueue) and thus here the main queue waits (sync) until all of logingQueue jobs are completed.
    /// Then it executes the block within logingQueue.sync which is empty, so it continues on doing other things.
    func waitForLogingJobsToFinish() {
        logingQueue.sync {
            //
        }
    }

}
