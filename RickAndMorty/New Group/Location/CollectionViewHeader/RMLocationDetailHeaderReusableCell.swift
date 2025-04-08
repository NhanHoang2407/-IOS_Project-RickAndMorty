//
//  RMLocationDetailHeaderReusableCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 7/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMLocationDetailHeaderReusableCell: UICollectionReusableView {
    
    static let cellIdentifier = "RMLocationDetailHeaderReusableCell"
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor.white
        label.text = "CollectionView Header"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(container)
        container.addSubview(headerLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            container.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            container.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            container.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            headerLabel.topAnchor.constraint(equalTo: container.topAnchor),
            headerLabel.leftAnchor.constraint(equalTo: container.leftAnchor),
            headerLabel.rightAnchor.constraint(equalTo: container.rightAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),

        ])
    }
}
