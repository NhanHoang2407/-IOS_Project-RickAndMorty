//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 25/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMSettingsCellViewModel {
    public var title: String {
        settingType.title
    }
    public var iconImage: UIImage? {
        settingType.iconImg
    }
    public var iconBackgroundColor: UIColor {
        settingType.iconBackgroundColor
    }
    public var settingsCatagoryURL: URL? {
        settingType.settingCatagoryURL
    }
    
    private let settingType: SettingCatagory
    
    init(settingType: SettingCatagory) {
        self.settingType = settingType
    }
}
