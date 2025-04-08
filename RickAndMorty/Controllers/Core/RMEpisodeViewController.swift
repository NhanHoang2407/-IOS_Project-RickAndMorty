//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/27/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

final class RMEpisodeViewController: UIViewController {
    
    let episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Episodes"
        view.backgroundColor = UIColor.clear
        episodeListView.delegate = self
        self.view.addSubview(episodeListView)
        addContraints()
        addSearchBtn()
    }
    
    private func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let searchVC = RMSearchViewController(config: .init(type: .episode))
        searchVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func addContraints() {
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ])

    }
    
    deinit{
        print("Episode: Deinit")
    }

}

extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        let episodeDetailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        navigationController?.pushViewController(episodeDetailVC, animated: true)
    }

}
