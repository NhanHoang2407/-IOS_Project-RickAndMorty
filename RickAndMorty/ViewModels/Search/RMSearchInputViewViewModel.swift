//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 7/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
protocol RMSearchInputViewViewModelDelegate: AnyObject {
    func updateButtonTitle(option: RMSearchInputViewViewModel.DynamicOptions, title: String)
}
class RMSearchInputViewViewModel {
    private let type: RMSearchViewController.Config.`Type`
    
    enum DynamicOptions: String {
        case status = "STATUS"
        case gender = "GENDER"
        case locationType = "LOCATION TYPE"
        
        public var choices: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
            case .gender:
                return ["female", "male", "genderless", "unknown"]
            case .locationType:
                return ["planet", "cluster", "microverse"]
            }
        }
        
        public var queryParam: String {
            switch self {
            case .status:
                return "status"
            case .gender:
                return "gender"
            case .locationType:
                return "type"
            }
        }
            
        public var buttonTag: Int {
            switch self {
            case .status:
                return 1
            case .gender:
                return 2
            case .locationType:
                return 3
            }
        }
    }
    
    weak var delegate: RMSearchInputViewViewModelDelegate?
        
    public var shouldHaveDynamicOptions: Bool {
        switch type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }
    
    public var options: [DynamicOptions] {
        switch self.type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }
    
    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }

    public func updateButtonTitle(option: RMSearchInputViewViewModel.DynamicOptions, title: String) {
        delegate?.updateButtonTitle(option: option, title: title)
    }
}
