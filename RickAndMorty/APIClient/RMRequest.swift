//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/28/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import Foundation

/// make API request
final class RMRequest {
    //base url
    //endpoint
    //path components
    // query arguments
    
    private struct Constants {
        static let baseURL:String = "https://rickandmortyapi.com/api"
    }
    
    private let endPoint: RMEndpoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public var urlString: String {
        var string: String = Constants.baseURL
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach { (element) in
                string += "/\(element)"
            }
        }
        
        if !queryParameters.isEmpty {
            let joinedString = queryParameters.compactMap({ (element)->String? in
                guard let value = element.value else {
                    return nil
                }
                let newString = "?\(element.name)=\(value)"
                return newString
            }).joined()
            string += joinedString
        }
        return string
    }
    
    init(endPoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}
