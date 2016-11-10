//
//  LogListTableViewController.swift
//  2N-mobile-communicator
//
//  Created by Martin Troup on 09.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit

class LogListTableViewController: UIViewController {
    
    let logListTableView = UITableView()
    
    let fileLoggerTableViewDatasource = FileLoggerTableViewDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(logListTableView)
        
        logListTableView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: logListTableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: logListTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: logListTableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: logListTableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])

        logListTableView.delegate = self
        logListTableView.dataSource = fileLoggerTableViewDatasource
        logListTableView.register(FileLoggerTableViewCell.self, forCellReuseIdentifier: QuantiLoggerConstants.FileLoggerTableViewDatasource.fileLoggerTableViewCellIdentifier)
    }
}

extension LogListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


