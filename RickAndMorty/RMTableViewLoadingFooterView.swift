//
//  RMTableViewLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 28/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMTableViewLoadingFooterView: UITableViewHeaderFooterView {
    
    static let footerIdentifier: String = "RMTableViewLoadingFooterView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .large)
        spinner.hidesWhenStopped = true
        spinner.color = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(spinner)
        contentView.backgroundColor = .white
        spinner.startAnimating()

        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported.")
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

        ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.startAnimating()
    }
}
