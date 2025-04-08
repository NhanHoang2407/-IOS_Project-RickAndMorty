//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 27/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMLocationView: UIView {
    private var viewModel: RMLocationViewViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.spinner.stopAnimating()
                weakSelf.tableView.reloadData()
                weakSelf.tableView.isHidden = false
                
            }
        }
    }

    public let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        tableView.register(RMTableViewLoadingFooterView.self, forHeaderFooterViewReuseIdentifier: RMTableViewLoadingFooterView.footerIdentifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        self.addSubview(spinner)
        self.translatesAutoresizingMaskIntoConstraints = false
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    func configure(with viewModel: RMLocationViewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - private
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
