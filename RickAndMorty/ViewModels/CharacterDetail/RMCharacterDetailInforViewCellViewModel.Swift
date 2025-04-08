//
//  RMCharacterDetailInforViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 19/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
import UIKit

final class RMCharacterDetailInforViewCellViewModel {
    private let type: CharacterInfor
    private let value: String
    
    public var title: String {
        type.displayTitle
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        dateFormatter.timeZone = .current
        
        return dateFormatter
    }()
    
    static let shortFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    public var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        if type == .created {
            if let date = Self.dateFormatter.date(from: value) {
                return Self.shortFormatter.string(from: date)
            }
        }
        
        return value
    }
    
    
    public var iconImage: UIImage? {
        type.displayIcon
    }
    public var tintColor: UIColor {
        type.displayTintColor
    }
        
    enum CharacterInfor {
        case status
        case species
        case type
        case gender
        case origin
        case location
        case created
        case episodes
        
        var displayTitle: String {
            switch self {
            case .status:
                return "STATUS"
            case .species:
                return "SPECIES"
            case .type:
                return "TYPE"
            case .gender:
                return "GENDER"
            case .origin:
                return "ORIGIN"
            case .location:
                return "LOCATION"
            case .created:
                return "CREATED"
            case .episodes:
                return "TOTAL EPISODES"
            }
        }
        
        var displayIcon: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "leaf.circle.fill")
            case .species:
                return UIImage(systemName: "globe.americas.fill")
            case .type:
                return UIImage(systemName: "questionmark.square.dashed")
            case .gender:
                return UIImage(systemName: "person.fill")
            case .origin:
                return UIImage(systemName: "person.text.rectangle.fill")
            case .location:
                return UIImage(systemName: "location.circle.fill")
            case .created:
                return UIImage(systemName: "calendar.and.person")
            case .episodes:
                return UIImage(systemName: "list.bullet.rectangle.fill")
            }
        }
        
        var displayTintColor: UIColor {
            switch self {
            case .status:
                return UIColor.blue
            case .species:
                return UIColor.orange
            case .type:
                return UIColor.red
            case .gender:
                return UIColor.systemYellow
            case .origin:
                return UIColor.systemTeal
            case .location:
                return UIColor.purple
            case .created:
                return UIColor.systemPink
            case .episodes:
                return UIColor.systemIndigo
            }

        }
    }
    
    // init function
    init(type: CharacterInfor, value: String) {
        self.type = type
        self.value = value
    }

}
