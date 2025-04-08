//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 28/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

protocol RMLocationTableViewCellViewModelDelegate: AnyObject {
    func setUpCell(_ location: RMLocation)
}

class RMLocationTableViewCellViewModel {
    
    private let location: RMLocation
    
    
    weak var delegate: RMLocationTableViewCellViewModelDelegate?
    
    init(location: RMLocation) {
        self.location = location
    }
    
    func loadCell() {
        delegate?.setUpCell(location)
    }
}
