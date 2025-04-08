//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by IC DEV on 1/10/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    public var episodes: [String] {
        character.episode
    }
    
    public var title: String {
        return character.name.uppercased()
    }
    
    public var sections: [SectionType] = []
    
    init(character: RMCharacter) {
        self.character = character
        setUpSections()
    }
    
    enum SectionType {
        case photo (RMCharacterDetailPhotoViewCellViewModel)
        case information ([RMCharacterDetailInforViewCellViewModel])
        case episodes ([RMCharacterDetailEpisodeViewCellViewModel])
    }
    
    private func setUpSections() {
        sections = [.photo(.init(imgURL: URL(string: character.image))),
                    .information([.init(type: .status, value: character.status.text),
                                  .init(type: .species, value: character.species),
                                  .init(type: .type, value: character.type),
                                  .init(type: .gender, value: character.gender.rawValue),
                                  .init(type: .origin, value: character.origin.name),
                                  .init(type: .location, value: character.location.name),
                                  .init(type: .created, value: character.created),
                                  .init(type: .episodes, value: "\(character.episode.count)")
                             ]),
                .episodes(character.episode.compactMap({
                    return RMCharacterDetailEpisodeViewCellViewModel(episodeURL: URL(string: $0))
                }))
        ]
    }
}
