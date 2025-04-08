//
//  RMLocationDetailInforTableViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 3/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMLocationDetailInforTableViewCell: UICollectionViewCell {

    static let cellIdentifier = "RMLocationDetailInforTableViewCell"
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        return view
    }()
    
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
        self.addSubview(contentContainer)
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(valueLabel)
        addConstraint()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported.")
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentContainer.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            contentContainer.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            contentContainer.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            titleLabel.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -5),
            
            valueLabel.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -5),
            
        ])
    }
    
    private func setUpStyle() {
        self.backgroundColor = .clear
        self.contentView.clipsToBounds = true
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }

    func configure(with viewModel: RMLocationDetailInforTableViewCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.titleLabel.text = viewModel.displayTitle
            weakSelf.valueLabel.text = viewModel.displayValue
        }
    }

}
