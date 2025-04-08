//
//  RMCharacterDetailInforViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 19/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
import UIKit

class RMCharacterDetailInforViewCell: UICollectionViewCell {
    static let rmCharacterDetailPhotoViewCellIdentifier: String = "RMCharacterDetailInforViewCell"
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)

        return label
    }()
    
    private let titleContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .tertiaryLabel
        return container
    }()
    
    private let valueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private let iconImg: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    func addConstraint() {
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .systemGroupedBackground
        contentView.clipsToBounds = true

        NSLayoutConstraint.activate([
            titleContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            titleContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            titleContainer.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3),
            
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            
            iconImg.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            iconImg.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 48),
            iconImg.heightAnchor.constraint(equalToConstant: 35),
            iconImg.widthAnchor.constraint(equalToConstant: 35),
            
            valueLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: iconImg.trailingAnchor, constant: 5),
            valueLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: titleContainer.topAnchor)

        ])
    }
    
    func addViews() {
        contentView.addSubview(titleContainer)
        contentView.addSubview(valueLabel)
        contentView.addSubview(iconImg)
        titleContainer.addSubview(titleLabel)
    }
    
    func configure(viewModel: RMCharacterDetailInforViewCellViewModel) {
        self.titleLabel.text = viewModel.title
        self.titleLabel.textColor = viewModel.tintColor
        self.valueLabel.text = viewModel.displayValue
        self.iconImg.image = viewModel.iconImage
        self.iconImg.tintColor = viewModel.tintColor
        
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        valueLabel.text = nil
        iconImg.image = nil
        iconImg.tintColor = .label
        titleLabel.textColor = .label
        
    }
}
