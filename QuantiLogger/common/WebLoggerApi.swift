//
//  WebLoggerApi.swift
//  WebLoggerExample
//
//  Created by Jakub Prusa on 13.06.18.
//  Copyright © 2018 Jakub Prusa. All rights reserved.
//

import Foundation
import RxSwift

protocol WebLoggerApiType {
    func send(_ logBatch: LogEntryBatch) -> Completable
}

enum WebLoggerApiError: Error {
    case invalidUrl
}

class WebLoggerApi: BaseApi {

}

extension WebLoggerApi: WebLoggerApiType {
    func send(_ logBatch: LogEntryBatch) -> Completable {
        let request = ApiFactory.buildRequest(baseUrl: url, pathComponent: "log", method: .post, withJsonBody: logBatch.jsonData)

        return ApiFactory.noData(for: request, in: session).ignoreElements().asObservable().asCompletable()
    }
}
