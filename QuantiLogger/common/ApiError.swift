//
//  ApiError.swift
//  2N-mobile-communicator
//
//  Created by Martin Troup on 19/01/2018.
//  Copyright © 2018 quanti. All rights reserved.
//

import Foundation

enum ApiError: Error {
	case unknownSession
	// 400
	case badRequest
	// 401
	case unauthorized
	// 404
	case notFound
	// 5xx
	case serverFailure
	// any other status code
	case unspecified(Int)
	case parsingJsonFailure
	case invalidRequest

	static func == (lhs: ApiError, rhs: ApiError) -> Bool {
		switch (lhs, rhs) {
			 // swiftlint:disable:next empty_enum_arguments
		case (.unspecified(_), .unspecified(_)),
			 (.unknownSession, .unknownSession),
			 (.badRequest, .badRequest),
			 (.unauthorized, .unauthorized),
			 (.notFound, .notFound),
			 (.serverFailure, .serverFailure),
			 (.parsingJsonFailure, .parsingJsonFailure),
			 (.invalidRequest, .invalidRequest):
			return true
		default:
			return false
		}
	}

	static func === (lhs: ApiError, rhs: ApiError) -> Bool {
		switch (lhs, rhs) {
		case (.unspecified(let a), .unspecified(let b)):
			return a == b
		case (.unknownSession, .unknownSession),
			 (.badRequest, .badRequest),
			 (.unauthorized, .unauthorized),
			 (.notFound, .notFound),
			 (.serverFailure, .serverFailure),
			 (.parsingJsonFailure, .parsingJsonFailure),
			 (.invalidRequest, .invalidRequest):
			return true
		default:
			return false
		}
	}
}
