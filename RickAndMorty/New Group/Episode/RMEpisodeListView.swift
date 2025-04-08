//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 21/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit


protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode)
}

class RMEpisodeListView: UIView {

    var delegate: RMEpisodeListViewDelegate?
    
    // ViewModel for character list
    let viewModel = RMEpisodeListViewViewModel()
    
    // loading spinner appearing before data fetched
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.large)
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.black
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()
    
    // collection view for displaying characters
    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(RMCharacterDetailEpisodeViewCell.self, forCellWithReuseIdentifier: RMCharacterDetailEpisodeViewCell.rmCharacterDetailPhotoViewCellIdentifier)
        collection.register(RMLoadingFooterCollectionReusableView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: RMLoadingFooterCollectionReusableView.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.white
        collection.isHidden = true
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        addSubview(collectionView)
        addConstraints()
        
        spinner.startAnimating()
        viewModel.fetchEpisodes()
        viewModel.delegate = self
        setUpCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Unsupport")
    }
    
    // add contraints for spinner and collection
    func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
            ])
    }
    
    // set up datasource and delegate for collection
    func setUpCollectionView(){
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
    


}

extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
    func didLoadInitialEpisodes() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
    
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: newIndexPaths)
        })
    }
}
