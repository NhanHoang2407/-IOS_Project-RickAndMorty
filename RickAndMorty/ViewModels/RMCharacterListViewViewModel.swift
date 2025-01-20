//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by IC DEV on 12/2/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit
protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: RMCharacter)
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
}
final class RMCharacterListViewViewModel: NSObject {
    weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingData: Bool = false
    
    private var characterArray: [RMCharacter] = [] {
        didSet {
            let oldCount = oldValue.count
            let newElements = characterArray[oldCount...]
            
            for character in newElements {
                let viewModel: RMCharacterCollectionViewCellViewModel = RMCharacterCollectionViewCellViewModel(characterName:
                    character.name, characterStatus: character.status, characterImg: URL(string: character.image))
                cellViewModelArray.append(viewModel)
            }
        }
    }
    private var cellViewModelArray: [RMCharacterCollectionViewCellViewModel] = []
    private var apiInfor: RMGetAllCharactersResponses.Infor? = nil
    
    // fetch characters from api
    func fetchCharacters(){
        RMService.shared.execute(request: .listCharactersRequests, expecting: RMGetAllCharactersResponses.self) { [weak self] (result) in
            switch result{
            case .success(let data):
                self?.characterArray = data.results
                self?.apiInfor = data.info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
//                print("success case")
            case .failure(let error):
                print(error)
                print("Error case.")
            }
        }
    }
    
    public var shouldShowLoadIndicator: Bool {
        return apiInfor?.next != nil
    }
    
    
    public func fetchAdditionalCharacters(url: URL) {
//        guard !isLoadingData else {
//            return
//        }
        isLoadingData = true
        print("Fetching Data")
        guard let request = RMRequest(url: url) else {
            print("Fail to load data")
            isLoadingData = false
            return
        }        
        RMService.shared.execute(request: request, expecting: RMGetAllCharactersResponses.self) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            switch result {
            case .success(let data):
                let originalCount = weakSelf.characterArray.count
                let newCount = data.results.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex...(startingIndex+newCount-1)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                weakSelf.characterArray.append(contentsOf: data.results)
                weakSelf.apiInfor = data.info
                
                
                print("characters: \(self?.characterArray.count ?? 0) cellModels: \(self?.cellViewModelArray.count ?? 0)")
                DispatchQueue.main.async {
                    weakSelf.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                    weakSelf.isLoadingData = false
                }
                print(String.init(describing: data))
            case .failure(let error):
                weakSelf.isLoadingData = false
                print(String.init(describing: error))
            }
        }
    }
}

// MARK: COLLECTION VIEW

// collection view data source
extension RMCharacterListViewViewModel: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as! RMCharacterCollectionViewCell
        let cellModel: RMCharacterCollectionViewCellViewModel = cellViewModelArray[indexPath.row]
        cellModel.delegate = cell
        cellModel.loadCell()
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
extension RMCharacterListViewViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character: RMCharacter = characterArray[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

// collection view flow layout delegate
extension RMCharacterListViewViewModel: UICollectionViewDelegateFlowLayout {
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
        let itemWidth = (screenWidth - 30) / 2
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadIndicator else {
            return CGSize(width: collectionView.frame.width, height: 0)

        }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

// collection view scroll
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
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
                fetchAdditionalCharacters(url: url)
            }
        }
    }
}
