//
//  RMSettingsViewViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 25/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

class RMSettingsViewViewModel {
// MARK: Attributes
    public var cellViewModels: [RMSettingsCellViewModel]
    
    init(cellViewModels: [RMSettingsCellViewModel]) {
        self.cellViewModels = cellViewModels
    }
    
}
