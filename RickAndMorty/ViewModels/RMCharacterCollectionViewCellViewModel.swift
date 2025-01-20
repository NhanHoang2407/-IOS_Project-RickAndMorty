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
    private let characterImgUrl: URL?
    public var characterStatusText: String {
        return characterStatus.text
    }
    
    weak var delegate: RMCharacterCollectionViewCellViewModelDelegate?
    
    init(characterName: String, characterStatus: RMCharacterStatus, characterImg: URL?) {
        self.characterName = characterName
        self.characterStatus  = characterStatus
        self.characterImgUrl = characterImg
    }
    
    func loadImg(completion: @escaping(Result<Data, APIError>)->Void) {
        guard let characterImgUrl = characterImgUrl else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: characterImgUrl)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Can't download character's image.")
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    func loadCell() {
        self.delegate?.setUpCell(viewModel: self)
    }
}
