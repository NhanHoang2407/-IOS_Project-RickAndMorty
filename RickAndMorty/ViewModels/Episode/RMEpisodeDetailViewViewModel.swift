//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 24/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didLoadEpisodeCharacters()
}

class RMEpisodeDetailViewViewModel {
    private let episodeURL: URL?
    
    public var episodeCharacterTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didLoadEpisodeCharacters()
        }
    }
    
    // MARK: Public
    
    // section type of collectionView
    enum SectionType {
        case inforCell([RMEpisodeDetailInforCollectionViewCellViewModel])
        case characterCell([RMCharacterCollectionViewCellViewModel])
    }
    
    weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    // cellViewModels array
    public private(set) var cellViewModels: [SectionType] = []
    
    init (episodeURL: URL?) {
        self.episodeURL = episodeURL
        
    }
    
    // fetch episode from url
    func fetchEpisode() {
        guard let url = episodeURL, let request = RMRequest(url: url) else {
            return
        }
        print("URL: \(url)")
        RMService.shared.execute(request: request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let episode):
                self?.fetchCharacters(episode: episode)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    // MARK: Private
    
    // create viewModels for cell from dataTuple
    func createCellViewModels() {
        guard let dataTuple = episodeCharacterTuple else {
            return
        }
        
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        cellViewModels = [
            .inforCell([
                .init(type: .episode, value: episode.episode),
                .init(type: .name, value: episode.name),
                .init(type: .date, value: episode.air_date)
            ]),
            .characterCell(
                characters.compactMap({ character in
                    return RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImg: URL(string: character.image))
                })
            )
        ]
    }
    
    // fetch all characters of an episode
    private func fetchCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap { characterString in
            return URL(string: characterString)
        }.compactMap { characterURL in
            return RMRequest(url: characterURL)
        }
        
        let dispatchGroup = DispatchGroup()
        var characters:[RMCharacter] = []
        
        for request in requests {
            dispatchGroup.enter()
            
            RMService.shared.execute(request: request, expecting: RMCharacter.self) { result in
                
                defer {
                    dispatchGroup.leave()
                }
                
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.episodeCharacterTuple = (episode: episode, characters: characters)
        }
    }
    
}
