//
//  APIError.swift
//  RickAndMorty
//
//  Created by IC DEV on 12/10/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import Foundation
enum APIError: Error {
    case invalidURL
    case noData
    case decodeError
    case decodingError
    case unknownError(String)
}
