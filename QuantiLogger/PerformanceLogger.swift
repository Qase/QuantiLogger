//
//  PerformanceLogger.swift
//  QuantiLogger
//
//  Created by Jakub Prusa on 21.08.17.
//  Copyright © 2017 quanti. All rights reserved.
//

import Foundation

/// Pre-built logger that wraps system os_logger
public class PerformanceLogger: InternalBaseLogger, Logging {

    public init(subsystem: String, category: String) {
        super.init()

    }

    override public init() {

    }

    public func levels() -> [Level] {
        return levels
    }

    public func log(_ message: String, onLevel level: Level) {
        sleep(1)
    }

}
