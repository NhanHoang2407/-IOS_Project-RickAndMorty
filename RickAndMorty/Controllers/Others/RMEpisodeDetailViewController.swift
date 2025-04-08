//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 21/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMEpisodeDetailViewController: UIViewController {
    
    private let episodeURL: URL?
    private let detailView: RMEpisodeDetailView = RMEpisodeDetailView()
    private let viewModel: RMEpisodeDetailViewViewModel

    init(url: URL?) {
        self.episodeURL = url
        self.viewModel = RMEpisodeDetailViewViewModel(episodeURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Episode detail"
        self.view.addSubview(detailView)
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
        viewModel.delegate = self
        viewModel.fetchEpisode()
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

        ])
    }
}

// MARK: EpisodeDetailViewViewModel Delegate

extension RMEpisodeDetailViewController: RMEpisodeDetailViewViewModelDelegate {
    func didLoadEpisodeCharacters() {
        detailView.configure(with: viewModel)
    }
}

// MARK: CollectionView Delegate

extension RMEpisodeDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let viewModelArray = viewModel.cellViewModels[indexPath.section]
        switch viewModelArray {
        case .inforCell:
            return
        case .characterCell:
            guard let characters = viewModel.episodeCharacterTuple?.characters else {
                return
            }
            let targetCharacter = characters[indexPath.row]
            let characterDetailViewModel = RMCharacterDetailViewViewModel(character: targetCharacter)
            let characterDetailVC = RMCharacterDetailViewController(viewModel: characterDetailViewModel)
            characterDetailVC.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(characterDetailVC, animated: true)
        }
    }
    
}

// MARK: CollectionView DataSource


extension RMEpisodeDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellViewModels = viewModel.cellViewModels
        switch cellViewModels[section] {
        case .inforCell(let viewModels):
            return viewModels.count
        case .characterCell(let viewModels):
            return viewModels.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModels = viewModel.cellViewModels[indexPath.section]
        switch cellViewModels {
        case .characterCell(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as! RMCharacterCollectionViewCell

            let cellModel: RMCharacterCollectionViewCellViewModel = viewModels[indexPath.row]
            cellModel.delegate = cell
            cellModel.loadCell()
            
            return cell
        
        case .inforCell(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeDetailInforCollectionViewCell.cellIdentifier, for: indexPath) as! RMEpisodeDetailInforCollectionViewCell
            let targetViewModel = viewModels[indexPath.row]
            cell.configure(with: targetViewModel)
            
            return cell
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.cellViewModels.count
    }
}
