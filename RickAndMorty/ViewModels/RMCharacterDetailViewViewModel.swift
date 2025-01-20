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
    
    public var title: String {
        return character.name.uppercased()
    }
    init(character: RMCharacter) {
        self.character = character
    }
}
