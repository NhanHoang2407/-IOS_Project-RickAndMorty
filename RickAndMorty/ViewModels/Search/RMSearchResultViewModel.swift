//
//  RMSearchResultViewViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 11/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
protocol RMSearchResultViewModelDelegate: AnyObject {
    func didLoadMoreCell(with newIndexPaths: [IndexPath])
}

final class RMSearchResultViewModel {
    public var apiInfor: Infor? = nil
    public var isLoading: Bool = false
    public var shouldShowIndicator: Bool {
        return (apiInfor?.next != nil) ? true : false
    }
    
    weak var delegate: RMSearchResultViewModelDelegate?
    
    public let viewModelCatagory: ElementCatagory
    public var characterCellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    public var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    public var episodeCellViewModels: [RMCharacterDetailEpisodeViewCellViewModel] = []
    public var characterArray: [RMCharacter] = [] {
        didSet {
            let newElements = characterArray.suffix(from: oldValue.count)
            for character in newElements {
                let viewModel: RMCharacterCollectionViewCellViewModel = RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImg: URL(string: character.image))
                characterCellViewModels.append(viewModel)
            }
        }
    }
    public var locationArray: [RMLocation] = [] {
        didSet {
            let newElements = locationArray.suffix(from: oldValue.count)
            for location in newElements {
                let viewModel = RMLocationTableViewCellViewModel(location: location)
                locationCellViewModels.append(viewModel)
            }
        }
    }
    public var episodeArray: [RMEpisode] = [] {
        didSet {
            let newElements = episodeArray.suffix(from: oldValue.count)
            for episode in newElements {
                let viewModel = RMCharacterDetailEpisodeViewCellViewModel(episodeURL: URL(string: episode.url))
                episodeCellViewModels.append(viewModel)
            }
        }
    }
    
    enum ElementCatagory {
        case character([RMCharacter])
        case location([RMLocation])
        case episode([RMEpisode])
    }
    
    init(catagory: ElementCatagory, apiInfor: Infor?){
        self.viewModelCatagory = catagory
        switch catagory {
        case .character(let array):
            characterArray.append(contentsOf: array)
            characterCellViewModels.append(contentsOf: array.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImg: URL(string: character.image))
            }))
        case .location(let array):
            locationArray.append(contentsOf: array)
            locationCellViewModels.append(contentsOf: array.compactMap({ location in
                return RMLocationTableViewCellViewModel(location: location)
            }))
        case .episode(let array):
            episodeArray.append(contentsOf: array)
            episodeCellViewModels.append(contentsOf: array.compactMap({ episode in
                return RMCharacterDetailEpisodeViewCellViewModel(episodeURL: URL(string: episode.url))
            }))
        }
        self.apiInfor = apiInfor
    }
    
    public func fetchAdditionalElements() {
        guard let apiInfor = apiInfor,
              let nextURLString = apiInfor.next,
              let url = URL(string: nextURLString),
              let request = RMRequest(url: url),
              isLoading == false else {
            return
        }
        isLoading = true
        switch viewModelCatagory {
        case .character:
            fetchData(request: request, expecting: RMGetAllCharactersResponses.self) { [weak self] result in
                self?.handleFetchResult(result: result, oldViewModels: self?.characterArray ?? [], completion: { newViewModels in
                    self?.characterArray.append(contentsOf: newViewModels)
                })
            }
        case .location:
            fetchData(request: request, expecting: RMGetAllLocationsResponses.self) { [weak self] result in
                self?.handleFetchResult(result: result, oldViewModels: self?.locationArray ?? [], completion: { newViewModels in
                    self?.locationArray.append(contentsOf: newViewModels)
                })
            }
        case .episode:
            fetchData(request: request, expecting: RMGetAllEpisodesResponses.self) { [weak self] result in
                self?.handleFetchResult(result: result, oldViewModels: self?.episodeArray ?? [], completion: { newViewModels in
                    self?.episodeArray.append(contentsOf: newViewModels)
                })
            }
        }
    }
    // make api call
    private func fetchData<T: Codable>(request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T, APIError>)->Void) {
        RMService.shared.execute(request: request, expecting: type, completion: completion)
    }
    // handle result fetched from api call
    private func handleFetchResult<T: Decodable, U>(result: Result<T, APIError>, oldViewModels: [U], completion appendElements: @escaping ([U])->Void){
        switch result {
        case .success(let model):
            let elements: [U]
            let indexPathToAdd: [IndexPath]
            if let characterResponses = model as? RMGetAllCharactersResponses {
                elements = characterResponses.results as! [U]
                apiInfor = characterResponses.info
                indexPathToAdd = calculateIndexPathToAdd(oldViewModelsCount: oldViewModels.count, newViewModelsCount: elements.count)
            } else if let locationResponses = model as? RMGetAllLocationsResponses {
                elements = locationResponses.results as! [U]
                indexPathToAdd = calculateIndexPathToAdd(oldViewModelsCount: oldViewModels.count, newViewModelsCount: elements.count)
                apiInfor = locationResponses.info
            } else if let episodeResponses = model as? RMGetAllEpisodesResponses {
                elements = episodeResponses.results as! [U]
                indexPathToAdd = calculateIndexPathToAdd(oldViewModelsCount: oldViewModels.count, newViewModelsCount: elements.count)
                apiInfor = episodeResponses.info
            } else {
                isLoading = false
                return
            }
            appendElements(elements)
            DispatchQueue.main.async { [weak self] in
                // update UI
                self?.delegate?.didLoadMoreCell(with: indexPathToAdd)
                self?.isLoading = false
            }
            self.isLoading = false
        case .failure(let failure):
            isLoading = false
            print(String(describing: failure))
        }
    }
    // calculte indexPath for additional elements
    private func calculateIndexPathToAdd(oldViewModelsCount: Int, newViewModelsCount: Int)->[IndexPath]{
        let totalCount = oldViewModelsCount + newViewModelsCount
        let startingIndex = totalCount - newViewModelsCount
        return Array(startingIndex..<totalCount).compactMap ({
            return IndexPath(row: $0, section: 0)
        })
    }
}
