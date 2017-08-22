//
//  LogFilesViaMail.swift
//  QuantiLogger
//
//  Created by Martin Troup on 09.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit
import MessageUI

public class LogFilesViaMailViewController: MFMailComposeViewController {

    public init(withRecipients recipients: [String]) {
        super.init(nibName: nil, bundle: nil)

        setSubject("iOS log files from application")
        setToRecipients(recipients)

        addLogFilesViaAttachments()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLogFilesViaAttachments() {
        guard let _logFilesUrls = FileLoggerManager.shared.gettingAllLogFiles() else { return }
        for logFileUrl in _logFilesUrls {
            guard let logFileContent = FileLoggerManager.shared.readingContentFromLogFile(at: logFileUrl) else {
                break
            }
            guard let logFileData = logFileContent.data(using: .utf8) else {
                break
            }
            addAttachmentData(logFileData, mimeType: "text/plain", fileName: logFileUrl.lastPathComponent)
        }
    }
}
