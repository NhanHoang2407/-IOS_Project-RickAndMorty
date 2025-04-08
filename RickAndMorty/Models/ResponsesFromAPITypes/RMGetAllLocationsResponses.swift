//
//  RMGetAllLocationsResponses.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 27/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

struct RMGetAllLocationsResponses: Codable {
//    struct Infor: Codable {
//        let count: Int
//        let pages: Int
//        let next: String?
//        let prev: String?
//    }
    let info: Infor
    let results: [RMLocation]
}
