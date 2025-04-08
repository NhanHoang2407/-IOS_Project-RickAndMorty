//
//  RMEpisodeDetailInforCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 25/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMEpisodeDetailInforCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMEpisodeDetailInforCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.sizeToFit()
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 27, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Value"
        label.numberOfLines = 0

        
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
        addConstraint()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported.")
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -5),
            
            valueLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5)
        ])
    }
    
    private func setUpStyle() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    func configure(with viewModel: RMEpisodeDetailInforCollectionViewCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.titleLabel.text = viewModel.displayTitle
            weakSelf.valueLabel.text = viewModel.displayValue
        }
    }
}
