//
//  File.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 7/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//


        headerView.backgroundColor = UIColor.lightGray
        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 23)
        headerLabel.textColor = UIColor.white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        switch viewModel.cellViewModels[section] {
        case .inforCell(_):
            headerLabel.text = "Location Information"
        case .characterCell(_):
            headerLabel.text = "Characters Information"
        }
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            ])