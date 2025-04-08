//
//  RMLocationDetailInforTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 3/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

class RMLocationDetailInforTableViewCellViewModel {
    private let type: cellInforType
    private let value: String
    
    public var displayTitle: String {
        type.title
    }
    
    public var displayValue: String {
        if value.elementsEqual("unknown") {
            return "Unknown."
        }
        if value.isEmpty {
            return "None"
        }
        return value
    }
    
    init(type: cellInforType, value: String) {
        self.type = type
        self.value = value
    }
    
    enum cellInforType {
        case name
        case type
        case dimension
        
        var title: String {
            switch self {
            case .name:
                return "Name: "
            case .type:
                return "Type: "
            case .dimension:
                return "Dimension: "
            }
        }
    }
}
