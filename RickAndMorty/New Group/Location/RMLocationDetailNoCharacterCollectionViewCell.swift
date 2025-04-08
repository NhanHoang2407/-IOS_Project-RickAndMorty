//
//  RMLocationDetailNoCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 4/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMLocationDetailNoCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier: String = "RMLocationDetailNoCharacterCollectionViewCell"
    
    private var image: UIImageView = {
        let imageContent = UIImage(systemName: "person.crop.circle.badge.exclamationmark.fill")
        let img = UIImageView(image: imageContent)
        img.tintColor = .black
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Characters"
        label.sizeToFit()
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(image)
        self.contentView.addSubview(errorLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            image.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            image.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15),
            errorLabel.centerXAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
        ])
    }
}
