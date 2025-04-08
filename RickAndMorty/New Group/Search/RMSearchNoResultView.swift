//
//  RMSearchNoResultView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 6/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMSearchNoResultView: UIView {
    private let viewModel: RMSearchNoResultViewViewModel = RMSearchNoResultViewViewModel()
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let icon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(icon)
        self.addSubview(title)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
        addConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: self.topAnchor),
            icon.leftAnchor.constraint(equalTo: self.leftAnchor),
            icon.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: self.leftAnchor),
            title.rightAnchor.constraint(equalTo: self.rightAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func configure() {
        title.text = viewModel.title
        icon.image = viewModel.image
    }
}
