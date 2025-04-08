//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by IC DEV on 1/10/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel
    private let detailView: RMCharacterDetailView
    
    init(viewModel: RMCharacterDetailViewViewModel){
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapShare))
        addConstraints()
    }
    
    @objc func didTapShare() {
        print("Shared tapped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ])
    }
}

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = viewModel.sections
        switch sections[section] {
        case .photo:
            return 1
        case .information(let inforSection):
            return inforSection.count
        case .episodes(let episodeSection):
            return episodeSection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sections = viewModel.sections
        switch sections[indexPath.section] {
        case .photo (let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterDetailPhotoViewCell.rmCharacterDetailPhotoViewCellIdentifier, for: indexPath) as! RMCharacterDetailPhotoViewCell
            
            cell.configure(viewModel: viewModel)
            return cell
        case .information (let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterDetailInforViewCell.rmCharacterDetailPhotoViewCellIdentifier, for: indexPath) as! RMCharacterDetailInforViewCell
            cell.configure(viewModel: viewModels[indexPath.row])
            return cell
        case .episodes (let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterDetailEpisodeViewCell.rmCharacterDetailPhotoViewCellIdentifier, for: indexPath) as! RMCharacterDetailEpisodeViewCell            
            
            cell.configure(viewModel: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sections = viewModel.sections
        switch sections[indexPath.section] {
        case .photo, .information:
            return
        case .episodes:
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]
            let episodeDetail = RMEpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(episodeDetail, animated: true)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
}
