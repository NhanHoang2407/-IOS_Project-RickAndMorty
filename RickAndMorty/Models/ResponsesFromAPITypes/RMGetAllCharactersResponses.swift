//
//  RMGetAllCharactersResponses.swift
//  RickAndMorty
//
//  Created by IC DEV on 12/2/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import Foundation

// list of characters including info of list
struct RMGetAllCharactersResponses: Codable {
    struct Infor: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Infor
    let results: [RMCharacter]
}
