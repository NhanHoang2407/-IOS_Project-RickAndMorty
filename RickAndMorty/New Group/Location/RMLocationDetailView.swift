//
//  RMLocationDetailView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 28/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMLocationDetailView: UIView {
    public let collectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.register(RMLocationDetailInforTableViewCell.self, forCellWithReuseIdentifier: RMLocationDetailInforTableViewCell.cellIdentifier)
        collectionView.register(RMLocationDetailCollectionViewTableViewCell.self, forCellWithReuseIdentifier: RMLocationDetailCollectionViewTableViewCell.cellIdentifier)
        collectionView.register(RMLocationDetailHeaderReusableCell.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: RMLocationDetailHeaderReusableCell.cellIdentifier)
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        return collectionView
    }()
    
    // loading spinner
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.large)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        addSubview(collectionView)
        addConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([            
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
}

extension RMLocationDetailView: RMLocationDetailViewViewModelDelegate {
    func didLoadLocationCharacters() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.stopAnimating()
            self?.collectionView.isHidden = false
            self?.collectionView.reloadData()
        }
    }
}
