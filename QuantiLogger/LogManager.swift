//
//  LoggingManager.swift
//  QuantiLogger
//
//  Created by Martin Troup on 25.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation

/// Global method that handles loging. Once the LogManager is set and all necessary loggers are registered somewhere
/// at the beginning of the application, this method can be called throughout the whole project in order to log.
///
/// - Parameters:
///   - message: String loging message
///   - level: Level of the loging message
public func QLog(_ message: String, onLevel level: Level) {
    LogManager.shared.log(message, onLevel: level)
}


/// LogManager manages different types of loggers. The class enables to register custom or pre-built loggers.
/// Each of these logger classes must be subclassed from BaseLogger. The class handles logging to registered loggers
/// based on levels they are set to acccept.
public class LogManager {
    
    // The class is used as a Singleton, thus should be accesed via instance property !!!
    public static let shared = LogManager()
    
    private var loggers: [Loging]
    
    private init() {
        loggers = [Loging]()
    }
    
    
    /// Method to register a new custom or pre-build logger.
    ///
    /// - Parameter logger: Logger to be registered.
    public func add(_ logger: Loging) {
        logger.configure()
        loggers.append(logger)
    }
    
    
    /// Method to remove all existing loggers registered to the Log manager.
    public func removeAllLoggers() {
        loggers = [Loging]()
    }
    
    
    /// Method to handle logging, it is called internaly via global method QLog(_, _) and thus its not visible outside
    /// of the module.
    ///
    /// - Parameters:
    ///   - message: String logging message
    ///   - level: Level of the logging message
    func log(_ message: String, onLevel level: Level) {
        if loggers.count == 0 {
            assertionFailure("No loggers were added to the manager.")
            return
        }
        for logger in loggers {
            if logger.doesLog(forLevel: level) {
                logger.log(message, onLevel: level)
            }
        }
    }
    
    
}
