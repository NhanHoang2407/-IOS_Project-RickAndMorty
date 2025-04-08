//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 28/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didLoadLocationCharacters()
}

class RMLocationDetailViewViewModel {
    private let location: RMLocation
    
    weak var delegate: RMLocationDetailViewViewModelDelegate?
    public var locationCharacterTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didLoadLocationCharacters()
        }
    }
    public var cellViewModels: [SectionType] = []

    // MARK: init
    init(location: RMLocation) {
        self.location = location
    }
    //MARK: enum
    enum SectionType {
        case inforCell([RMLocationDetailInforTableViewCellViewModel])
        case characterCell([RMCharacterCollectionViewCellViewModel])
    }
    
    //MARK: private function
    
    private func createCellViewModels() {
        guard let dataTupple = locationCharacterTuple else {
            return
        }
        let characters = dataTupple.characters
        let location = dataTupple.location
        cellViewModels = [
            .inforCell([.init(type: .name, value: location.name),
                        .init(type: .type, value: location.type),
                        .init(type: .dimension, value: location.dimension)]),
            .characterCell(
                characters.compactMap({ character in
                    return .init(characterName: character.name, characterStatus: character.status, characterImg: URL(string: character.image))
                })
            )
        ]
    }
    
    // MARK: public function
    func fetchCharacters() {
        let characterRequest: [RMRequest] = location.residents.compactMap { characterStringURL in
            return URL(string: characterStringURL)
        }.compactMap {
            return RMRequest(url: $0)
        }
        
        let dispatchGroup = DispatchGroup()
        var characters: [RMCharacter] = []
        
        for request in characterRequest {
            dispatchGroup.enter()
            RMService.shared.execute(request: request, expecting: RMCharacter.self) { result in
                
                defer {
                    dispatchGroup.leave()
                }
                
                switch result {
                case .success(let character):
                    characters.append(character)
                case .failure(_):
                    break
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.locationCharacterTuple = (location: weakSelf.location, characters: characters)
        }
    }
}
