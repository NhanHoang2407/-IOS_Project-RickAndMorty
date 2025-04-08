//
//  RMCharacterDetailEpisodeViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 19/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
import UIKit

final class RMCharacterDetailEpisodeViewCell: UICollectionViewCell {
    static let rmCharacterDetailPhotoViewCellIdentifier: String = "RMCharacterDetailEpisodeViewCell"
    
    private let episodeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .semibold)

        return label
    }()
    
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addConstraint()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    func addConstraint(){
        contentView.addSubview(episodeLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            episodeLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            episodeLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            episodeLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            nameLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

    }
    
    func setUpUI() {
        contentView.backgroundColor = UIColor.systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func configure(viewModel: RMCharacterDetailEpisodeViewCellViewModel) {
        viewModel.fetchEpisode { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episodeLabel.text = "Episode " + model.episode
                    self?.nameLabel.text = model.name
                    self?.dateLabel.text = "Aired on " + model.air_date
                }

            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        episodeLabel.text = nil
        nameLabel.text = nil
        dateLabel.text = nil
    }
}
