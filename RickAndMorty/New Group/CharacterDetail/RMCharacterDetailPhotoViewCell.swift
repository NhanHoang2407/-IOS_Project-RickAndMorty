//
//  RMCharacterPhotoViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 19/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//
import Foundation
import UIKit

final class RMCharacterDetailPhotoViewCell: UICollectionViewCell {
    static let rmCharacterDetailPhotoViewCellIdentifier: String = "RMCharacterDetailPhotoViewCell"
    
    // UI Elements
    private let characterImage: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 8
        imgView.contentMode = UIViewContentMode.scaleAspectFill
            
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(characterImage)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: self.topAnchor),
            characterImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            characterImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            characterImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func configure(viewModel: RMCharacterDetailPhotoViewCellViewModel) {
        viewModel.loadCharacterImg { [weak self] result in
            switch result {
            case .success(let data):
                self?.characterImage.image = UIImage(data: data)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterImage.image = nil
    }
}
