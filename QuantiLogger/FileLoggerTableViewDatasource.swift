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
    
    public override init() {
        super.init()
        
        let fileLoggerManager = FileLoggerManager.shared
        guard let _logDirUrl = fileLoggerManager.logDirUrl else { return }
        
        for index in 0..<fileLoggerManager.numOfLogFiles {
            let logFileNumber = (fileLoggerManager.currentLogFileNumber + index) % fileLoggerManager.numOfLogFiles
            let logFileUrl = _logDirUrl.appendingPathComponent("\(logFileNumber)").appendingPathExtension("log")
            
            let logFileRecords = fileLoggerManager.gettingRecordsFromLogFile(at: logFileUrl)
            if let _logFileRecords = logFileRecords {
                logFilesRecords.append(contentsOf: _logFileRecords)
            }
        }
    }
    
    open func gettingCell(_ tableView: UITableView, forRowAt indexPath: IndexPath, withLogFileRecord: LogFileRecord) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuantiLoggerConstants.FileLoggerTableViewDatasource.fileLoggerTableViewCellIdentifier, for: indexPath) as! FileLoggerTableViewCell
        cell.logFileRecord = logFilesRecords[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return gettingCell(tableView, forRowAt: indexPath, withLogFileRecord: logFilesRecords[indexPath.row])
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logFilesRecords.count
    }

}
