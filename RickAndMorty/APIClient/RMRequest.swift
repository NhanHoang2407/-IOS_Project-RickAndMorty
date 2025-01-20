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
    
    // request baseURL
    private struct Constants {
        static let baseURL:String = "https://rickandmortyapi.com/api"
    }
    // request endpoint
    private let endPoint: RMEndpoint
    // request path components array
    private let pathComponents: [String]
    // request query parameters array
    private let queryParameters: [URLQueryItem]
    
    public var url: URL? {
        return URL(string: urlString)
    }
    // computing argument url string
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
                
                let newString = "\(element.name)=\(value)"
                return newString
            }).joined(separator: "&")
            string += "?" + joinedString
        }
        return string
    }
    
    // contructor for request (url)
    init(endPoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseURL){
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL+"/", with: "")
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty{
                let endpoint = components[0]

                if let rmEndpoint = RMEndpoint(rawValue: endpoint) {
                    self.init(endPoint: rmEndpoint)
                    return
                }

            }
        } else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpoint = components[0]
                let queryItemsString = components[1]
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    let queryComponents = $0.components(separatedBy: "=")
                    return URLQueryItem(name: queryComponents[0], value: queryComponents[1])
                })
                
                if let rmEndpoint = RMEndpoint(rawValue: endpoint) {
                    self.init(endPoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}
extension RMRequest {
    // static request for get all character (first page)
    static let listCharactersRequests = RMRequest(endPoint: .character)
}
