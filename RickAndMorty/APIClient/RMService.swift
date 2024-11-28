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
    func execute(request: RMRequest, completion: @escaping ()->Void) -> Void {
        print("executed")
    }
}
