//
//  WebLogger.swift
//  WebLoggerExample
//
//  Created by Jakub Prusa on 5/17/18.
//  Copyright © 2018 Jakub Prusa. All rights reserved.
//

import Foundation
import QuantiLogger
import RxSwift

extension Level: JSONSerializable {
    var jsonRepresentation: AnyObject {
        return self.rawValue as AnyObject
    }
}

struct LogEntry: JSONSerializable {

    let severity: Level
    let timestamp: Double
    let message: String
    let sessionName = "ios-12345"

    func severityValue(severity: Level) -> String {
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
    private var logs = [LogEntry]()

    init(logs: [LogEntry]) {
        self.logs = logs
    }

    mutating func add(log: LogEntry) {
        logs.append(log)
    }

    mutating func clearLogs() {
        logs = [LogEntry]()
    }

    var jsonRepresentation: AnyObject {
        return logs.jsonRepresentation
    }

}

public class WebLogger: QuantiLogger.Logging {

    private let api = WebLoggerApi(url: "http://localhost:3000/api/v1")

    private let logSubject = ReplaySubject<LogEntry>.create(bufferSize: 10)

    private let bag = DisposeBag()

    open func configure() {

        let bufferTimeSpan: RxTimeInterval = 4
        let bufferMaxCount = 4

        logSubject
            .buffer(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance)
            .filter { $0.count > 0 }
            .map { LogEntryBatch(logs: $0) }
            .flatMap { logBatch -> Completable in
                guard let _api = self.api else {
                    return Completable.error(WebLoggerApiError.invalidUrl)
                }

                return _api.send(logBatch)
            }
            .do(onCompleted: {
                print("XXX")
            })
            .subscribe()
            .disposed(by: bag)

    }

    open func log(_ message: String, onLevel level: Level) {
        //do some fancy logging

        let entry = LogEntry(severity: level, timestamp: NSDate().timeIntervalSince1970, message: message)
        logSubject.onNext(entry)
    }

    open func levels() -> [Level] {
        return [.verbose, .info, .debug, .warn, .error]
    }

}
