//
//  RMLocationDetailCollectionViewTableViewCell.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 3/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

protocol RMLocationDetailCollectionViewTableViewCellDelegate: AnyObject {
    func rmLocationDetailCollectionViewTableViewCell(_ locationDetailCollectionViewTableViewCell: RMLocationDetailCollectionViewTableViewCell, didSelectCharacter character: RMCharacter)
}

class RMLocationDetailCollectionViewTableViewCell: UICollectionViewCell {
    
    static let cellIdentifier: String = "RMLocationDetailCollectionViewTableViewCell"
    
    public var viewModel: RMLocationDetailCollectionViewTableViewCellViewModel?
    
    weak var delegate: RMLocationDetailCollectionViewTableViewCellDelegate?
        
    private let layout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    public let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMLocationDetailNoCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMLocationDetailNoCharacterCollectionViewCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        return collectionView

    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        self.contentView.addSubview(collectionView)
        addConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
        
    func configure(viewModel: RMLocationDetailCollectionViewTableViewCellViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.viewModel = viewModel
            weakSelf.collectionView.dataSource = viewModel
            weakSelf.collectionView.delegate = viewModel
            weakSelf.viewModel?.delegate = weakSelf
            weakSelf.collectionView.reloadData()
        }
    }
}

// MARK: ViewModel Delegate

extension RMLocationDetailCollectionViewTableViewCell: RMLocationDetailCollectionViewTableViewCellViewModelDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmLocationDetailCollectionViewTableViewCell(self, didSelectCharacter: character)
    }

}
