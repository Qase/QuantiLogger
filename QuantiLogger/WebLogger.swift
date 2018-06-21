//
//  WebLogger.swift
//  WebLoggerExample
//
//  Created by Jakub Prusa on 5/17/18.
//  Copyright © 2018 Jakub Prusa. All rights reserved.
//

import Foundation
import RxSwift

struct LogEntry: JSONSerializable {
    let severity: Level
    let timestamp: Double
    let message: String
    let sessionName: String

    var jsonRepresentation: AnyObject {
        return [
            "severity": severityValue(severity),
            "timestamp": timestamp,
            "message": message,
            "sessionName": sessionName
        ] as AnyObject
    }

    func severityValue(_ severity: Level) -> String {
        switch severity {
        case .warn:
            return "WARNING"
        case .system, .process:
            return "INFO"
        default:
            return severity.rawValue.uppercased()
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

public class WebLogger: InternalBaseLogger, Logging {
    // Default value is UUID which is same until someone reinstal the application
    public var sessionName = UUID().uuidString

    // Size of batch which is send to server API
    // In other word, lengt of array whith LogEntries
    public var sizeOfBatch = 5

    // After this time interval LogEntries are send to server API, regardless of their amount
    public var timeSpan: RxTimeInterval = 4

    public var urlString: String = WebLogger.defaultUrlString {
        didSet {
            guard let _api = WebLoggerApi(url: urlString) else {
                print("\(#function) - could not create an URL instance out of provided URL string.")
                return
            }

            self.api = _api
        }
    }

    private static let defaultUrlString = "http://localhost:3000/api/v1"

    private var api = WebLoggerApi(url: WebLogger.defaultUrlString)

    private let logSubject = ReplaySubject<LogEntry>.create(bufferSize: 10)

    private let bag = DisposeBag()

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

    open func log(_ message: String, onLevel level: Level) {
        //do some fancy logging

        let entry = LogEntry(severity: level, timestamp: NSDate().timeIntervalSince1970, message: message, sessionName: sessionName)
        logSubject.onNext(entry)
    }

    open func levels() -> [Level] {
        return [.verbose, .info, .debug, .warn, .error]
    }

}
