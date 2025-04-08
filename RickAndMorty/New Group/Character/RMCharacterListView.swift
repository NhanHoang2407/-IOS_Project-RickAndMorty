//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by IC DEV on 12/2/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter)
}

// view handles showing list of characters
class RMCharacterListView: UIView {
    
    var delegate: RMCharacterListViewDelegate?
    
    // ViewModel for character list
    let viewModel = RMCharacterListViewViewModel()
    
    // loading spinner appearing before data fetched
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.large)
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // collection view for displaying characters
    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
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
        viewModel.fetchCharacters()
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

extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: newIndexPaths)
        })
    } 
    
    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }
    
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
}
