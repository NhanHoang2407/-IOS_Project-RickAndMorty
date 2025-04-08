//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 28/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit
 

class RMLocationTableViewCell: UITableViewCell {
    static let cellIdentifier: String = "RMLocationTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private let dimensionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .tertiaryLabel
        return label
    }()
    


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(dimensionLabel)
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func addConstraint() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            typeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),

            dimensionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            dimensionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dimensionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            dimensionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
        ])
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        typeLabel.text = nil
        dimensionLabel.text = nil
    }
}

extension RMLocationTableViewCell: RMLocationTableViewCellViewModelDelegate {
    func setUpCell(_ location: RMLocation) {
        nameLabel.text = location.name
        typeLabel.text = "Type: " + location.type
        dimensionLabel.text = "Dimension: " + (!location.dimension.isEmpty ? location.dimension : "None")
    }
    
    
}
