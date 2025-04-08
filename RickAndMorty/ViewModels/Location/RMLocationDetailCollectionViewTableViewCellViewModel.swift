//
//  RMLocationDetailCollectionViewTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 4/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
import UIKit

protocol RMLocationDetailCollectionViewTableViewCellViewModelDelegate: AnyObject {
    func didSelectCharacter(_ character: RMCharacter)
}

class RMLocationDetailCollectionViewTableViewCellViewModel: NSObject {
    private let cellViewModels: [RMCharacterCollectionViewCellViewModel]
    private var characters: [RMCharacter]?
    
    weak var delegate: RMLocationDetailCollectionViewTableViewCellViewModelDelegate?
    
    init(cellViewModels: [RMCharacterCollectionViewCellViewModel], characters: [RMCharacter]?) {
        self.cellViewModels = cellViewModels
        self.characters = characters
    }
}

// MARK: collectionView DataSource
extension RMLocationDetailCollectionViewTableViewCellViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cellViewModels.count == 0) ? 1 : cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellViewModels.count == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMLocationDetailNoCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMLocationDetailNoCharacterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                return UICollectionViewCell()
            }
            let targetViewModel = cellViewModels[indexPath.row]
            targetViewModel.delegate = cell
            targetViewModel.loadCell()
            return cell
        }
    }
}
// MARK: collectionView Delegate
extension RMLocationDetailCollectionViewTableViewCellViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let characters = characters else { return }
        let targetChar = characters[indexPath.row]
        delegate?.didSelectCharacter(targetChar)
    }
}

// MARK: collectionView layout Delegate
extension RMLocationDetailCollectionViewTableViewCellViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - 20
        if cellViewModels.count == 0 {
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        else {
            let itemWidth = availableWidth / 2
            return CGSize(width: itemWidth, height: 300)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
}
