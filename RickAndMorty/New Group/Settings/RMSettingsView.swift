//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 25/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMSettingsView: UIView {
// MARK: Attribute
    public let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 8
        tableView.register(RMSettingsTableViewCell.self, forCellReuseIdentifier: RMSettingsTableViewCell.cellIdentifier)
        return tableView
    }()

// MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: Private function
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
