//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 21/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMEpisodeDetailView: UIView {
    var collectionView: UICollectionView?
    private var viewModel: RMEpisodeDetailViewViewModel?
    private var isLoading: Bool = true
    
    // loading spinner
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.large)
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spinner.startAnimating()
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        self.addSubview(collectionView)
        self.addSubview(spinner)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported.")
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    // create collectionView
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RMEpisodeDetailInforCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeDetailInforCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        return collectionView
    }
    
    // configure section style
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        guard let viewModel = viewModel else {
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        switch viewModel.cellViewModels[sectionIndex] {
        case .inforCell:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        case .characterCell:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.7)), subitems: [item, item])
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        print("configure function")
        self.viewModel = viewModel
        
        DispatchQueue.main.async { [weak self] in
            self?.spinner.stopAnimating()
            self?.collectionView?.reloadData()
            self?.collectionView?.isHidden = false
        }
    }
    
}
