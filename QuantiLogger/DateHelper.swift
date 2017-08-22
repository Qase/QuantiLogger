//
//  DateHelper.swift
//  QuantiLogger
//
//  Created by Jakub Prusa on 22.08.17.
//  Copyright © 2017 quanti. All rights reserved.
//

import Foundation

struct DateTimeHelper{

    static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()


    static func toFullDateTimeString(from date: Date = Date()) -> String {
        return DateTimeHelper.dateTimeFormatter.string(from: date)
    }

    static func toFullDateString(from date: Date = Date()) -> String {
        return DateTimeHelper.dateFormatter.string(from: date)
    }
}
