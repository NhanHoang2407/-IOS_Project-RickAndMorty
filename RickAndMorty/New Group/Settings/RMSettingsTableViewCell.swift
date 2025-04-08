//
//  RMSettingsTableViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 26/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMSettingsTableViewCell: UITableViewCell {
    static let cellIdentifier: String = "RMSettingsTableViewCell"
    
    private let iconImgView: UIImageView = {
        let iconImg: UIImageView = UIImageView()
        iconImg.translatesAutoresizingMaskIntoConstraints = false
        iconImg.contentMode = .scaleAspectFit
        iconImg.tintColor = .white
        return iconImg
    }()
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        return label
    }()
    // MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageContainer.addSubview(iconImgView)
        self.contentView.addSubview(imageContainer)
        self.contentView.addSubview(title)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Ussuported.")
    }
    
    override func prepareForReuse() {
        self.title.text = nil
        self.iconImgView.image = nil
        self.imageContainer.backgroundColor = .clear
    }
    
    func configure(with viewModel: RMSettingsCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.title.text = viewModel.title
            weakSelf.iconImgView.image = viewModel.iconImage
            weakSelf.imageContainer.backgroundColor = viewModel.iconBackgroundColor
        }
    }
    
// MARK: private function
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            imageContainer.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageContainer.widthAnchor.constraint(equalToConstant: 30),
            imageContainer.heightAnchor.constraint(equalToConstant: 30),
            
            iconImgView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            iconImgView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            iconImgView.heightAnchor.constraint(equalToConstant: 20),
            iconImgView.widthAnchor.constraint(equalToConstant: 20),

            title.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: imageContainer.safeAreaLayoutGuide.trailingAnchor, constant: 10),

        ])
    }

}
