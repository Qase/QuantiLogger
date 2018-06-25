//
//  ConsoleLogger.swift
//  QuantiLogger
//
//  Created by Martin Troup on 25.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import Foundation

/// Pre-built logger that logs to the console.
public class ConsoleLogger: Logging {
    public var levels: [Level] = [.info]

	public init() {}
	
    public func log(_ message: String, onLevel level: Level) {
        print("\(messageHeader(forLevel: level)) \(message)")
    }

}
