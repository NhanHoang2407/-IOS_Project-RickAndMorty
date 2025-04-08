//
//  RMEpisodeInforCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 24/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

class RMEpisodeDetailInforCollectionViewCellViewModel {
    private let value: String
    private let type: cellInforType
    
    public var displayTitle: String {
        type.title
    }
    public var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        return value
    }
    
    init (type: cellInforType, value: String) {
        self.value = value
        self.type = type
    }
    
    enum cellInforType {
        case name
        case date
        case episode
        
        var title: String {
            switch self {
            case .name:
                return "Name: "
            case .date:
                return "Date on air: "
            case .episode:
                return "Episode: "
            }
        }
    }
}
