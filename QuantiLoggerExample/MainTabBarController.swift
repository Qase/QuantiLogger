//
//  MainTabBarController.swift
//  QuantiLogger
//
//  Created by Martin Troup on 10.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    private let logListTab = 0
    private let sendLogFilesViaMailTab = 1

    let logListTableViewController = LogListTableViewController()
    let sendLogFilesViaMailViewController = SendLogFilesViaMailViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [logListTableViewController, sendLogFilesViaMailViewController]
        logListTableViewController.tabBarItem = UITabBarItem(title: "Log list", image: #imageLiteral(resourceName: "call_tab_icon"), tag: logListTab)
        sendLogFilesViaMailViewController.tabBarItem = UITabBarItem(title: "Send mail", image: #imageLiteral(resourceName: "graph_tab_icon"), tag: sendLogFilesViaMailTab)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Delegate methods
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //
    }
}
