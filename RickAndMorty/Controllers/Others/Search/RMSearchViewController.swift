//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 6/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMSearchViewController: UIViewController {
    private let config: Config
    private let searchView: RMSearchView
    private let viewModel: RMSearchViewViewModel
    
    struct Config {
        enum `Type` {
            case character
            case location
            case episode
            
            var title: String {
                switch self {
                case .character:
                    return "Search Character"
                case .location:
                    return "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
            
            var endpoint: RMEndpoint {
                switch self {
                case .character:
                    return .character
                case .location:
                    return .location
                case .episode:
                    return .episode
                }
            }
        }
        
        let type: `Type`
    }
    
    init(config: Config) {
        self.config = config
        self.viewModel = RMSearchViewViewModel(config: config)
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(searchView)
        searchView.delegate  = self
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = config.type.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(searchExecute))
    }
    
    @objc private func searchExecute() {
        searchView.showLoadingSpinner()
        viewModel.searchExecute(completion: searchView.hideLoadingSpinner)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }
}

extension RMSearchViewController: RMSearchViewDelegate {
    func rmSearchView<T>(_ searchView: RMSearchView, didSelectElement element: T) where T : Decodable, T : Encodable {
        if let character = element as? RMCharacter {
            let viewModel = RMCharacterDetailViewViewModel(character: character)
            let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
            detailVC.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(detailVC, animated: true)
        }
        else if let location = element as? RMLocation {
            let locationDetailViewModel = RMLocationDetailViewViewModel(location: location)
            let locationDetailVC = RMLocationDetailViewController(viewModel: locationDetailViewModel)
            navigationController?.pushViewController(locationDetailVC, animated: true)
        } else if let episode = element as? RMEpisode {
            let episodeDetailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
            navigationController?.pushViewController(episodeDetailVC, animated: true)
        }
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions) {
        let searchOptionVC = RMSearchOptionPickerViewController(option: option) { [weak self] choice in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.viewModel.updateDynamicOptionButton(optionTuple: (option, choice))
            }
        }
        searchOptionVC.sheetPresentationController?.prefersGrabberVisible = true
        searchOptionVC.sheetPresentationController?.detents = [.medium()]
        present(searchOptionVC, animated: true)
    }
}
