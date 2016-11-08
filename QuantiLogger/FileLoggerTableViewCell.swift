//
//  LogFileTableViewCell.swift
//  QuantiLogger
//
//  Created by Martin Troup on 08.11.16.
//  Copyright © 2016 quanti. All rights reserved.
//

import UIKit

class FileLoggerTableViewCell: UITableViewCell {
    
    var logFileRecord: LogFileRecord? {
        didSet {
            logHeaderLabel.text = logFileRecord!.header
            logBodyLabel.text = logFileRecord!.body
        }
    }
    
    private let logHeaderLabel = UILabel()
    private let logBodyLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        let vStackView = UIStackView()
        addSubview(vStackView)
        
        vStackView.axis = .vertical
        vStackView.spacing = 3.0
        
        let topOffset = NSLayoutConstraint(item: vStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 20)
        let bottomOffset = NSLayoutConstraint(item: vStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20)
        let leftOffset = NSLayoutConstraint(item: vStackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 20)
        let rightOffset = NSLayoutConstraint(item: vStackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -20)
        addConstraints([topOffset, bottomOffset, leftOffset, rightOffset])
        
        vStackView.addArrangedSubview(logHeaderLabel)
        vStackView.addArrangedSubview(logBodyLabel)
        
        logHeaderLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        if let _logFileRecord = logFileRecord {
            logHeaderLabel.text = _logFileRecord.header
            logBodyLabel.text = _logFileRecord.body
        }
        
        
    }

}
