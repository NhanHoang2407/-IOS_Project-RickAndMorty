//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by IC DEV on 12/10/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import Foundation

protocol RMCharacterCollectionViewCellViewModelDelegate: AnyObject {
    func setUpCell(viewModel: RMCharacterCollectionViewCellViewModel)
}

final class RMCharacterCollectionViewCellViewModel {
    let characterName: String
    private let characterStatus: RMCharacterStatus
    public let characterImgUrl: URL?
    public var characterStatusText: String {
        return characterStatus.text
    }
    
    weak var delegate: RMCharacterCollectionViewCellViewModelDelegate?
    
    init(characterName: String, characterStatus: RMCharacterStatus, characterImg: URL?) {
        self.characterName = characterName
        self.characterStatus  = characterStatus
        self.characterImgUrl = characterImg
    }
    
    func loadCell() {
        self.delegate?.setUpCell(viewModel: self)
    }
}
