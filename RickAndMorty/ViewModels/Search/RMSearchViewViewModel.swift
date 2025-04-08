//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 6/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
final class RMSearchViewViewModel {
    public let config: RMSearchViewController.Config
    public let searchInputViewViewModel: RMSearchInputViewViewModel
//    public var searchResultViewModel: RMSearchResultViewModel?
    private var optionMap: [RMSearchInputViewViewModel.DynamicOptions: String] = [:]
    private var searchText: String = ""
    private var searchResultsHandler: ((RMSearchResultViewModel)->Void)?
    private var noSearchResultsHandler: (()->Void)?
    
    init(config: RMSearchViewController.Config){
        self.config = config
        self.searchInputViewViewModel = RMSearchInputViewViewModel(type: config.type)
    }
    // search text configure
    public func setSearchText(text: String) {
        self.searchText = text
    }
    // change button title
    public func updateDynamicOptionButton(optionTuple: (RMSearchInputViewViewModel.DynamicOptions, String)) {
        searchInputViewViewModel.updateButtonTitle(option: optionTuple.0, title: optionTuple.1)
        optionMap[optionTuple.0] = optionTuple.1.lowercased()
    }
    public func registerSearchResultsHandler(block: @escaping (RMSearchResultViewModel)->Void) {
        self.searchResultsHandler = block
    }
    public func registerNoSearchResultsHandler(block: @escaping ()->Void) {
        self.noSearchResultsHandler = block
    }
    // search button click handler
    public func searchExecute(completion: @escaping () -> Void) {
        // create query parameters
        var queryParams = optionMap.compactMap { (key: RMSearchInputViewViewModel.DynamicOptions, value: String) in
            return URLQueryItem(name: key.queryParam, value: value)
        }
        queryParams.append(URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)))
        // create URl request
        let request = RMRequest(endPoint: config.type.endpoint, queryParameters: queryParams)
        print(request.urlString)
        // execute API call
        switch config.type {
        case .character:
            makeAPICall(RMGetAllCharactersResponses.self, request: request, completion: completion)
        case .location:
            makeAPICall(RMGetAllLocationsResponses.self, request: request, completion: completion)
        case .episode:
            makeAPICall(RMGetAllEpisodesResponses.self, request: request, completion: completion)
        }
    }
    private func makeAPICall<T: Codable>(_ type: T.Type, request: RMRequest, completion: @escaping () -> Void) {
        RMService.shared.execute(request: request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                completion()
                self?.processSearchResults(model: model)
            case .failure:
                print("Failed to search.")
                completion()
                self?.noSearchResultsHandler?()
            }
        }
    }
    private func processSearchResults(model: Codable) {
        var viewModel: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharactersResponses {
            viewModel = .init(catagory: .character(characterResults.results), apiInfor: characterResults.info)
        }
        else if let locationResults = model as? RMGetAllLocationsResponses {
            viewModel = .init(catagory: .location(locationResults.results), apiInfor: locationResults.info)
        }
        else if let episodeResults = model as? RMGetAllEpisodesResponses {
            viewModel = .init(catagory: .episode(episodeResults.results), apiInfor: episodeResults.info)
        }
        else {
            // Error: no results
        }
        if let viewModel = viewModel {
            if let block = searchResultsHandler {
                block(viewModel)
            }
        }
    }
}
