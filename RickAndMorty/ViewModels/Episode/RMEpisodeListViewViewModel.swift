//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by IC DEV on 12/2/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didSelectEpisode(_ episode: RMEpisode)
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
}
final class RMEpisodeListViewViewModel: NSObject {
    weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingData: Bool = false
    
    private var cellViewModelArray: [RMCharacterDetailEpisodeViewCellViewModel] = []

    private var episodeArray: [RMEpisode] = [] {
        didSet {
            let oldCount = oldValue.count
            let newElements = episodeArray[oldCount...]
            
            for episode in newElements {
                let viewModel: RMCharacterDetailEpisodeViewCellViewModel = RMCharacterDetailEpisodeViewCellViewModel(episodeURL: URL(string: episode.url))
                cellViewModelArray.append(viewModel)
            }
        }
    }
    private var apiInfor: Infor? = nil
    
    // fetch characters from api
    func fetchEpisodes(){
        RMService.shared.execute(request: .listEpisodesRequests, expecting: RMGetAllEpisodesResponses.self) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.episodeArray = data.results
                self?.apiInfor = data.info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(error)
                print("Error case.")
            }
        }
    }
    
    public var shouldShowLoadIndicator: Bool {
        return apiInfor?.next != nil
    }
    
    
    public func fetchAdditionalEpisodes(url: URL) {
        isLoadingData = true
        print("Fetching Data")
        guard let request = RMRequest(url: url) else {
            print("Fail to load data")
            isLoadingData = false
            return
        }
        RMService.shared.execute(request: request, expecting: RMGetAllEpisodesResponses.self) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            switch result {
            case .success(let data):
                let originalCount = weakSelf.episodeArray.count
                let newCount = data.results.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex...(startingIndex+newCount-1)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                weakSelf.episodeArray.append(contentsOf: data.results)
                weakSelf.apiInfor = data.info
                
                
                print("episode: \(self?.episodeArray.count ?? 0) cellModels: \(self?.cellViewModelArray.count ?? 0)")
                DispatchQueue.main.async {
                    weakSelf.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        weakSelf.isLoadingData = false
                    }
                }
            case .failure(let error):
                weakSelf.isLoadingData = false
                print(String.init(describing: error))
            }
        }
    }
}

// MARK: COLLECTION VIEW

// collection view data source
extension RMEpisodeListViewViewModel: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterDetailEpisodeViewCell.rmCharacterDetailPhotoViewCellIdentifier, for: indexPath) as! RMCharacterDetailEpisodeViewCell
        let cellModel: RMCharacterDetailEpisodeViewCellViewModel = cellViewModelArray[indexPath.row]
        
        cell.configure(viewModel: cellModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == "UICollectionElementKindSectionFooter" else {
            fatalError("Unexpected element kind")
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: RMLoadingFooterCollectionReusableView.identifier, for: indexPath) as! RMLoadingFooterCollectionReusableView
        
        return footer
    }
}

// collection view delegate
extension RMEpisodeListViewViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode: RMEpisode = episodeArray[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}

// collection view flow layout delegate
extension RMEpisodeListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 20)
        return CGSize(width: itemWidth, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadIndicator else {
            return CGSize(width: collectionView.frame.width, height: 0)

        }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

// collection view scroll
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadIndicator,
            !isLoadingData,
            let nextUrlString = apiInfor?.next,
            let url = URL(string: nextUrlString) else {
            return
        }
        
        
        let totalContentHeight = scrollView.contentSize.height
        let scrollViewHeight =  scrollView.frame.height
        let offset = scrollView.contentOffset.y

        if offset >= (totalContentHeight - scrollViewHeight - 120) {
            if !isLoadingData {
                fetchAdditionalEpisodes(url: url)
            }
        }
    }
}
