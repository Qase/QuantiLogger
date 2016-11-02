//
//  QuantiBaseLogger.swift
//  QuantiLogger
//
//  Created by Martin Troup on 25.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit


/// The Base class for all Loggers. If a new logger is to be developed, it must inherit from this class.
open class BaseLogger {
    private let levels: [Level]
    
    public init(withLevels levels: [Level]) {
        self.levels = levels
    }
    
    
    /// This method should be overriden in the subclass if there is any configuration before the logger is set to log.
    open func configure() {
    }
    
    
    /// Method to log. It is specific for each logger and thus it must be overriden in the subclass.
    ///
    /// - Parameters:
    ///   - message: String loging message
    ///   - level: Level of the loging message
    open func log(_ message: String, onLevel level: Level) {
        preconditionFailure("Method must be implemented within a subclass of BaseLogger")
    }
    
    
    /// Each Logger is initialized with an array of levels that is set to accept. This method checks if the
    /// logger is set to accept specific level.
    ///
    /// - Parameter level: Specific level that is being checked if it is accepted by the logger
    /// - Returns: True if the logger accepts the level passed as a parameter, false otherwise
    func doesLog(forLevel level: Level) -> Bool {
        return levels.contains(level)
    }
    
}
