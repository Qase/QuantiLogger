//
//  JSONParseable.swift
//  ciggy-time
//
//  Created by Martin Troup on 09/04/2018.
//  Copyright © 2018 ciggytime.com. All rights reserved.
//

import Foundation

protocol JSONParseable {
	associatedtype Object

	static func parse(from json: Any) -> Object?
	static func parse(fromJSONValue json: JSONValue) -> Object?
	static func parseMany(from json: Any) -> [Object]?
}

extension JSONParseable {
	static func parse(from json: Any) -> Object? {
		guard let _jsonValue = JSONValue.fromObject(object: json) else {
			print("Failed to parse Object data from JSON.")
			return nil
		}

		return parse(fromJSONValue: _jsonValue)
	}

	static func parseMany(from json: Any) -> [Object]? {
		guard let _jsonValue = JSONValue.fromObject(object: json) else {
			print("Failed to parse array of [Object] data from JSON.")
			return nil
		}

		guard let _parsedArray = _jsonValue.array else {
			print("Failed to parse [Object] from JSON.")
			return nil
		}

		return _parsedArray.compactMap { parse(fromJSONValue: $0) }
	}
}
