//
//  RMService.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/28/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import Foundation
import Alamofire

/// API service class
final class RMService {
    static let shared = RMService()
    
    private init(){}
    
    private let cacheManager = RMAPICacheManager()
    
    /// function to make API CAll
    /// Parameters:
    ///     --- request: url request to execute
    ///     --- type: specific type of generic
    ///     --- completion: closure handle result of api call
    func execute<T: Codable>(request: RMRequest, expecting type:T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = request.url else {
            completion(Result.failure(APIError.invalidURL))
            return
        }
        
        if let cachedData = self.cacheManager.cachedResponse(endpoint: request.endPoint, url: url) {
            print("Using cached data.")
            do {
                let decodedData = try JSONDecoder().decode(type.self, from: cachedData)
                completion(Result.success(decodedData))
            } catch {
                completion(Result.failure(APIError.decodeError))
            }
            
            return
        }
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    completion(Result.failure(APIError.noData))
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(type.self, from: data)
                    self.cacheManager.setCache(endpoint: request.endPoint, url: url, data: data)
                    completion(Result.success(decodedData))
                } catch {
                    completion(Result.failure(APIError.decodeError))
                }
            case .failure(_):
                completion(Result.failure(APIError.noData))
            }
        }
    }
}

