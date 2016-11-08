//
//  LogFileTableViewDatasource.swift
//  QuantiLogger
//
//  Created by Martin Troup on 07.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit

open class FileLoggerTableViewDatasource: NSObject, UITableViewDataSource {

    public var logFilesRecords = [LogFileRecord]()
    
    override init() {
        super.init()
        
        let manager = FileLoggerManager.shared
        for index in 0..<manager.numOfLogFiles {
            let logFileNumber = (manager.currentLogFileNumber + index) % manager.numOfLogFiles
            let logFileRecords = manager.gettingRecordsFromLogFile(withName: "\(logFileNumber).log")
            if let _logFileRecords = logFileRecords {
                logFilesRecords.append(contentsOf: _logFileRecords)
            }
        }
    }
    
    open func gettingCell(_ tableView: UITableView, forRowAt indexPath: IndexPath, withLogFileRecord: LogFileRecord) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.FileLoggerTableViewDatasource.fileLoggerTableViewCellIdentifier, for: indexPath) as! FileLoggerTableViewCell
        cell.logFileRecord = logFilesRecords[indexPath.row]
        return cell
    }
    
    public final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return gettingCell(tableView, forRowAt: indexPath, withLogFileRecord: logFilesRecords[indexPath.row])
    }

    public final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logFilesRecords.count
    }

}
