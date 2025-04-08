//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 21/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

final class RMAPICacheManager {
    private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    init() {
        setUpCache()
    }
    
    // MARK: - Public
    func cachedResponse(endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        let urlString = url.absoluteString as NSString
        return targetCache.object(forKey: urlString) as? Data
    }
        
    func setCache(endpoint: RMEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        let urlString = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: urlString)
    }
    
    // MARK: - Privare
    private func setUpCache() {
        RMEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
