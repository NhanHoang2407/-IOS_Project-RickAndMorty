//
//  RMCharacterDetailEpisodeViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 19/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

protocol RMEpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class RMCharacterDetailEpisodeViewCellViewModel {
    private let episodeURL: URL?
    private var isFetching: Bool = false
    private var episode: RMEpisode?

    
    init(episodeURL: URL?) {
        self.episodeURL = episodeURL
    }
    
    func fetchEpisode(completion: @escaping ((Result<RMEpisodeDataRender, APIError>)->Void) ) {
        
        guard !isFetching else {
            if let model = episode {
                completion(.success(model))
            }
            return
        }
        
        guard let url = episodeURL, let request = RMRequest(url: url) else {
            return
        }
        isFetching = true
        RMService.shared.execute(request: request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case let .success(model):
                self?.episode = model
                completion(.success(model))
            case .failure(_):
                completion(.failure(.invalidURL))
            }
            self?.isFetching = false
        }
    }
}
