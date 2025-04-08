//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 28/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMLocationDetailViewController: UIViewController {
    
    private let detailView = RMLocationDetailView()
    private let viewModel: RMLocationDetailViewViewModel
    
    init(viewModel: RMLocationDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .tertiarySystemGroupedBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Location Detail"
        view.addSubview(detailView)
        detailView.collectionView.dataSource = self
        detailView.collectionView.delegate = self
        viewModel.delegate = detailView
        viewModel.fetchCharacters()
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


}

// MARK: Character Click Delegate
extension RMLocationDetailViewController: RMLocationDetailCollectionViewTableViewCellDelegate {
    func rmLocationDetailCollectionViewTableViewCell(_ locationDetailCollectionViewTableViewCell: RMLocationDetailCollectionViewTableViewCell, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: Collection View Delegate
extension RMLocationDetailViewController: UICollectionViewDelegate {
    
}
// MARK: Collection View FlowLayout Delegate
extension RMLocationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellViewModels = viewModel.cellViewModels
        switch cellViewModels[indexPath.section] {
        case .inforCell(_):
            return CGSize(width: collectionView.frame.width, height: 150)
        case .characterCell(_):
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
// MARK: Collection View DataSource
extension RMLocationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellViewModels = viewModel.cellViewModels
        switch cellViewModels[section] {
        case .inforCell(let viewModels):
            return viewModels.count
        case .characterCell:
            return 1
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModels = viewModel.cellViewModels
        switch cellViewModels[indexPath.section] {
        case .inforCell(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMLocationDetailInforTableViewCell.cellIdentifier, for: indexPath) as? RMLocationDetailInforTableViewCell else {
                return UICollectionViewCell()
            }
            let targetViewModel = viewModels[indexPath.row]
            cell.isUserInteractionEnabled = false
            cell.configure(with: targetViewModel)
            return cell
        case .characterCell(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMLocationDetailCollectionViewTableViewCell.cellIdentifier, for: indexPath) as? RMLocationDetailCollectionViewTableViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = RMLocationDetailCollectionViewTableViewCellViewModel(cellViewModels: viewModels, characters: viewModel.locationCharacterTuple?.characters)
            cell.configure(viewModel: viewModel)
            cell.delegate = self
            return cell

        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == "UICollectionElementKindSectionHeader" else {
            fatalError("Unexpected element kind")
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: RMLocationDetailHeaderReusableCell.cellIdentifier, for: indexPath) as! RMLocationDetailHeaderReusableCell
        
        return header

    }
}
