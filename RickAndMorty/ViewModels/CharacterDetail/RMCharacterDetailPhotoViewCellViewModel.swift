//
//  RMCharacterDetailPhotoViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 19/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
final class RMCharacterDetailPhotoViewCellViewModel {
    private let imgURL: URL?
    
    init(imgURL: URL?) {
        self.imgURL = imgURL
    }
    
    func loadCharacterImg(completion: @escaping ((Result<Data, APIError>) -> Void)) {
        guard let imgURL = imgURL else {
            return
        }
        ImgLoader.shared.loadImg(url: imgURL) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
