//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 27/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didLoadInitialLocations()
    func didLoadMoreLocations(with nextIndex: [IndexPath])
}

final class RMLocationViewViewModel {
    public private(set) var locationArray: [RMLocation] = [] {
        didSet {
            let oldCount = oldValue.count
            let newElements = locationArray[oldCount...]
            
            for element in newElements {
                let cellViewModel = RMLocationTableViewCellViewModel(location: element)
                locationCellViewModels.append(cellViewModel)
            }
        }
    }
    
    public var shouldShowSpinner: Bool {
        return apiInfor?.next != nil
    }
    
    public private(set) var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var apiInfor: Infor? = nil
    
    public var isLoading: Bool = false
// MARK: -init
    init() {
        
    }
    func fetchLocations() {
        isLoading = true
        RMService.shared.execute(request: .listLocationsRequests, expecting: RMGetAllLocationsResponses.self) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let location):
                weakSelf.locationArray = location.results
                weakSelf.apiInfor = location.info
                weakSelf.isLoading = false
                weakSelf.delegate?.didLoadInitialLocations()
            case .failure(let error):
                weakSelf.isLoading = false
                print(String(describing: error))
            }
        }
    }
    
    func fetchMoreLocations() {
        guard let apiInfor = apiInfor,
              let nextURLString = apiInfor.next,
              let nextLocationURL = URL(string: nextURLString),
              let request = RMRequest(url: nextLocationURL),
              isLoading == false
             else { return }
        
        isLoading = true
        RMService.shared.execute(request: request, expecting: RMGetAllLocationsResponses.self) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            switch result {
            case .success(let additionalLocations):
                let originalCount = weakSelf.locationArray.count
                let newCount = additionalLocations.results.count
                let totalCount = originalCount + newCount
                let indexArray = Array(originalCount...(totalCount - 1)).compactMap {
                    return IndexPath(item: $0, section: 0)
                }
                weakSelf.locationArray.append(contentsOf: additionalLocations.results)
                weakSelf.apiInfor = additionalLocations.info
                
                DispatchQueue.main.async {
                    weakSelf.isLoading = false
                    weakSelf.delegate?.didLoadMoreLocations(with: indexArray)
                }
            case .failure(let error):
                weakSelf.isLoading = false
                print("error fetching locations: \(error)")
            }
        }
        
    }
}
