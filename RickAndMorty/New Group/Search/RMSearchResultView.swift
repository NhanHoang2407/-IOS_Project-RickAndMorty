//
//  RMSearchResultView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 11/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit
protocol RMSearchResultViewDelegate: AnyObject {
    func rmSearchResultView<T: Codable>(_ searchResultView: RMSearchResultView, didSelectElement element: T)
}

class RMSearchResultView: UIView {
    weak var delegate: RMSearchResultViewDelegate?
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            if let viewModel = viewModel {
                switch viewModel.viewModelCatagory {
                case .character, .episode:
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.reloadData()
                        self?.isHidden = false
                        self?.collectionView.isHidden = false
                        self?.tableview.isHidden = true
                    }
                case .location:
                    DispatchQueue.main.async { [weak self] in
                        self?.tableview.reloadData()
                        self?.isHidden = false
                        self?.tableview.isHidden = false
                        self?.collectionView.isHidden = true
                    }
                }
            }
        }
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterDetailEpisodeViewCell.self, forCellWithReuseIdentifier: RMCharacterDetailEpisodeViewCell.rmCharacterDetailPhotoViewCellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMLoadingFooterCollectionReusableView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: RMLoadingFooterCollectionReusableView.identifier)
        return collectionView
    }()
    
    private let tableview: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        tableview.isHidden = true
        return tableview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints  = false
        self.isHidden = true
        addConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstaints() {
        self.addSubview(collectionView)
        self.addSubview(tableview)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableview.delegate = self
        tableview.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            tableview.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableview.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            tableview.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
    }
}
//  table and collection view  scroll
extension RMSearchResultView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel?.isLoading == false,
              viewModel?.apiInfor != nil else {
            return
        }
        let totalContentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        let offset = scrollView.contentOffset.y
        
        if offset >= (totalContentHeight - scrollViewHeight - 50) {
            viewModel?.fetchAdditionalElements()
        }
    }
}
// collection view delegate
extension RMSearchResultView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        switch viewModel.viewModelCatagory {
        case .character:
            delegate?.rmSearchResultView(self, didSelectElement: viewModel.characterArray[indexPath.row])
        case .location:
            return
        case .episode:
            delegate?.rmSearchResultView(self, didSelectElement: viewModel.episodeArray[indexPath.row])
        }
    }
}
// collection view datasource
extension RMSearchResultView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            switch viewModel.viewModelCatagory {
            case .character:
                return viewModel.characterCellViewModels.count
            case .location:
                break
            case .episode:
                return viewModel.episodeCellViewModels.count
            }
        }
        return 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        switch viewModel.viewModelCatagory {
        case .character:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                return UICollectionViewCell()
            }
            let cellModel: RMCharacterCollectionViewCellViewModel = viewModel.characterCellViewModels[indexPath.row]
            cellModel.delegate = cell
            cellModel.loadCell()
            return cell
        case .location:
            break
        case .episode:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterDetailEpisodeViewCell.rmCharacterDetailPhotoViewCellIdentifier, for: indexPath) as? RMCharacterDetailEpisodeViewCell else {
                return UICollectionViewCell()
            }
            let cellModel: RMCharacterDetailEpisodeViewCellViewModel = viewModel.episodeCellViewModels[indexPath.row]
            
            cell.configure(viewModel: cellModel)
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == "UICollectionElementKindSectionFooter" else {
            fatalError("Unexpected element kind")
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: RMLoadingFooterCollectionReusableView.identifier, for: indexPath) as! RMLoadingFooterCollectionReusableView
        
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel?.shouldShowIndicator == true {
            return CGSize(width: collectionView.frame.width, height: 70)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
}
// collection view flow layout delegate
extension RMSearchResultView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel else {
            return CGSize(width: 0, height: 0)
        }
        switch viewModel.viewModelCatagory {
        case .character(_):
            return CGSize(width: (collectionView.frame.width / 2) - 5, height: 250)
        case .location(_):
            break
        case .episode(_):
            return CGSize(width: (collectionView.frame.width) , height: 150)
        }
        return CGSize(width: 0, height: 0)
    }
    
}
// tableView dataSource
extension RMSearchResultView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            switch viewModel.viewModelCatagory {
            case .character(_):
                break
            case .location:
                return viewModel.locationCellViewModels.count
            case .episode(_):
                break
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        switch viewModel.viewModelCatagory {
        case .character(_):
            break
        case .location:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else {
                return UITableViewCell()
            }
            let cellViewModel = viewModel.locationCellViewModels[indexPath.row]
            cellViewModel.delegate = cell
            cellViewModel.loadCell()
            return cell
            
        case .episode(_):
            break
        }
        return UITableViewCell()
    }
    
}
// tableView delegate
extension RMSearchResultView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        switch viewModel.viewModelCatagory {
        case .character:
            return
        case .location:
            delegate?.rmSearchResultView(self, didSelectElement: viewModel.locationArray[indexPath.row])
        case .episode:
            return
        }
    }
}

// viewModel delegate
extension RMSearchResultView: RMSearchResultViewModelDelegate {
    func didLoadMoreCell(with newIndexPaths: [IndexPath]) {
        guard let viewModel = viewModel else { return }
        switch viewModel.viewModelCatagory {
        case .character, .episode:
            collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.insertItems(at: newIndexPaths)
            }
        case .location:
            tableview.performBatchUpdates { [weak self] in
                self?.tableview.insertRows(at: newIndexPaths, with: .automatic)
            }
        }
    }
}
