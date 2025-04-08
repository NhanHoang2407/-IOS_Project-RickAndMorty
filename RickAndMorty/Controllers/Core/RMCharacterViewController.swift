//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/27/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

final class RMCharacterViewController: UIViewController {
    
    let characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters"
        view.backgroundColor = UIColor.clear
        characterListView.delegate = self
        self.view.addSubview(characterListView)
        addConstraints()
        addSearchBtn()
    }
    
    private func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let searchVC = RMSearchViewController(config: .init(type: .character))
        searchVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ])

    }
}

// MARK: RMCharacterListViewDelegate

extension RMCharacterViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
