//
//  QuantiBaseLogger.swift
//  QuantiLogger
//
//  Created by Martin Troup on 25.10.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit

public protocol Logging {
    func levels() -> [Level]
    func configure()
    func log(_ message: String, onLevel level: Level)
}

extension Logging {
    public func configure() {}
    
    func doesLog(forLevel level: Level) -> Bool {
        return levels().contains(level)
    }
}

