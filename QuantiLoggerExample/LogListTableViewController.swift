//
//  LogListTableViewController.swift
//  2N-mobile-communicator
//
//  Created by Martin Troup on 09.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit

class LogListTableViewController: UIViewController {
    private let refreshControl = UIRefreshControl()

    let logListTableView = UITableView()

    let fileLoggerTableViewDatasource = FileLoggerTableViewDatasource()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(logListTableView)

        logListTableView.translatesAutoresizingMaskIntoConstraints = false

        logListTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        logListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logListTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logListTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        logListTableView.delegate = self
        logListTableView.dataSource = fileLoggerTableViewDatasource
        logListTableView.register(FileLoggerTableViewCell.self, forCellReuseIdentifier: QuantiLoggerConstants.FileLoggerTableViewDatasource.fileLoggerTableViewCellIdentifier)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

        }


        // Pull to refresh
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        logListTableView.addSubview(refreshControl)
    }

    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        fileLoggerTableViewDatasource.reload()
        logListTableView.reloadData()

        refreshControl.endRefreshing()
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


