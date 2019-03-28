//  WebLogger.swift
//  WebLoggerExample
//
//  Created by Jakub Prusa on 5/17/18.
//  Copyright © 2018 Jakub Prusa. All rights reserved.
//

import Foundation
import RxSwift

struct LogEntry: JSONSerializable {
    let level: Level
    let timestamp: Double
    let message: String
    let sessionName: String

    var jsonRepresentation: AnyObject {
        return [
			"severity": serverLevelName(for: level),
            "timestamp": timestamp,
            "message": message,
            "sessionName": sessionName
        ] as AnyObject
    }

    private func serverLevelName(for level: Level) -> String {
        switch level {
        case .warn:
            return "WARNING"
        case .system, .process:
            return "INFO"
        default:
            return level.rawValue.uppercased()
        }
    }
}

struct LogEntryBatch: JSONSerializable {
    private var logs: [LogEntry]

    init(logs: [LogEntry] = []) {
        self.logs = logs
    }

    mutating func add(log: LogEntry) {
        logs.append(log)
    }

    mutating func clearLogs() {
        logs = []
    }

    var jsonRepresentation: AnyObject {
        return logs.jsonRepresentation
    }

}

public class WebLogger: Logging {
    // Default value is UUID which is same until someone reinstal the application
    public var sessionName = UUID().uuidString

    // Size of batch which is send to server API
    // In other word, lengt of array whith LogEntries
    public var sizeOfBatch = 5

    // After this time interval LogEntries are send to server API, regardless of their amount
    public var timeSpan: RxTimeInterval = 4

    public var serverUrl: String = WebLogger.defaultServerUrl {
        didSet {
            guard let _api = WebLoggerApi(url: serverUrl) else {
                print("\(#function) - could not create an URL instance out of provided URL string.")
                return
            }

            self.api = _api
        }
    }

    private static let defaultServerUrl = "http://localhost:3000/api/v1"

    private var api = WebLoggerApi(url: WebLogger.defaultServerUrl)

    private let logSubject = ReplaySubject<LogEntry>.create(bufferSize: 10)

    private let bag = DisposeBag()

	public init() {}

	convenience init(serverUrl: String, sessionName: String) {
		self.init()

		self.serverUrl = serverUrl
		self.sessionName = sessionName
	}

    open func configure() {
        logSubject
            .buffer(timeSpan: timeSpan, count: sizeOfBatch, scheduler: MainScheduler.instance)
            .filter { $0.count > 0 }
            .map { LogEntryBatch(logs: $0) }
            .flatMap { logBatch -> Completable in
                guard let _api = self.api else {
                    return Completable.error(WebLoggerApiError.invalidUrl)
                }

                return _api.send(logBatch)
            }
            .subscribe()
            .disposed(by: bag)

    }

	public var levels: [Level] = [.info]

    open func log(_ message: String, onLevel level: Level) {
        //do some fancy logging

        let entry = LogEntry(level: level, timestamp: NSDate().timeIntervalSince1970, message: message, sessionName: sessionName)
        logSubject.onNext(entry)
    }
}
