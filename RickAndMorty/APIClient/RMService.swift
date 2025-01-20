//
//  RMService.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/28/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import Foundation




/// API service class
final class RMService {
    static let shared = RMService()
    
    private init(){}
    
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
        print("URL: \(url)")
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(Result.failure(APIError.noData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(type.self, from: data)
                completion(Result.success(decodedData))
            } catch {
                completion(Result.failure(APIError.decodeError))
            }
            
        }.resume()

    }
}
