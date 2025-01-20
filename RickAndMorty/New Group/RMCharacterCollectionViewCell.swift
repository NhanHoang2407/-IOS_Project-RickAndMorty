//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by IC DEV on 12/10/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier: String = "RMCharacterCollectionViewCell"
    // UI Elements
    private let image: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 8
        imgView.contentMode = UIViewContentMode.scaleAspectFill
            
        return imgView
    }()
    // name label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // status label
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightText
        return label
    }()
    // init function
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(image)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.darkGray
        contentView.layer.cornerRadius = 8
        addElementConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.image.image = nil
        self.nameLabel.text = nil
        self.statusLabel.text = nil
    }
    // adding layout constraints for UI elements
    func addElementConstraint() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            image.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            image.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -15),
            
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -5),
            
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
    }
}

extension RMCharacterCollectionViewCell: RMCharacterCollectionViewCellViewModelDelegate {
    func setUpCell(viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = "Status: " + viewModel.characterStatusText
        
        viewModel.loadImg(){ [weak self] result in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self?.image.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
