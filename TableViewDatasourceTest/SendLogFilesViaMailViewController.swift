//
//  SendLogFilesViaMailViewController.swift
//  QuantiLogger
//
//  Created by Martin Troup on 10.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit
import MessageUI

class SendLogFilesViaMailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        if MFMailComposeViewController.canSendMail() {
            let logFilesViaMailViewController = LogFilesViaMailViewController(withRecipients: ["mbigmac@seznam.cz"])
            logFilesViaMailViewController.mailComposeDelegate = self
            
            present(logFilesViaMailViewController, animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email",
                                                       message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",
                                                       preferredStyle: .alert)
            sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                sendMailErrorAlert.dismiss(animated: true, completion: nil)
            }))
            
            present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
}

extension SendLogFilesViaMailViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
