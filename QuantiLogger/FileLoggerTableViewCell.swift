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
        contentView.addSubview(vStackView)
        
        vStackView.axis = .vertical
        vStackView.spacing = 3.0
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let topOffset = NSLayoutConstraint(item: vStackView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 10)
        let bottomOffset = NSLayoutConstraint(item: vStackView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -10)
        let leftOffset = NSLayoutConstraint(item: vStackView, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1, constant: 20)
        let rightOffset = NSLayoutConstraint(item: vStackView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: -20)
        contentView.addConstraints([topOffset, bottomOffset, leftOffset, rightOffset])
        
        vStackView.addArrangedSubview(logHeaderLabel)
        vStackView.addArrangedSubview(logBodyLabel)
        
        logHeaderLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        logBodyLabel.font = UIFont.systemFont(ofSize: 12.0)
        logBodyLabel.numberOfLines = 0
        
        
        if let _logFileRecord = logFileRecord {
            logHeaderLabel.text = _logFileRecord.header
            logBodyLabel.text = _logFileRecord.body
        }
        
        
    }

}
