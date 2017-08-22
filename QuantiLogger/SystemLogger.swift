//
//  SystemLogger.swift
//  QuantiLogger
//
//  Created by Martin Troup on 05/06/2017.
//  Copyright © 2017 quanti. All rights reserved.
//

import Foundation
import os

/// Pre-built logger that wraps system os_logger
public class SystemLogger: InternalBaseLogger, Logging {

    private var logger: OSLog?

    public init(subsystem: String, category: String) {
        super.init()

        logger = OSLog(subsystem: subsystem, category: category)
    }

    override public init() {
        assertionFailure("!!! init(subsystem: String, category: String) must be used to make SystemLogger work correctly !!!")
    }

    private func systemLevel(forLevel level: Level) -> OSLogType {
        switch level {
        case .info:
            return .info
        case .debug:
            return .debug
        case .verbose, .warn, .error:
            return .default
        case .system:
            return .fault
        case .process:
            return .error
        }
    }

    public func levels() -> [Level] {
        return levels
    }

    public func log(_ message: String, onLevel level: Level) {
        guard let _logger = logger else { return }

        let staticMessage = "\(messageHeader(forLevel: level)) \(message)"
        os_log("%@", log: _logger, type: systemLevel(forLevel: level), staticMessage)
    }

}
