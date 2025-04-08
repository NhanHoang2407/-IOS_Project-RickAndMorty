//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/27/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

final class RMLocationViewController: UIViewController {
    
    private let locationView = RMLocationView()
    private let viewModel = RMLocationViewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Locations"
        view.backgroundColor = UIColor.clear
        
        self.view.addSubview(locationView)
        locationView.tableView.dataSource = self
        locationView.tableView.delegate = self
        addConstraint()
        addSearchBtn()
        viewModel.delegate = self
        viewModel.fetchLocations()
        
    }
    
    private func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let searchVC = RMSearchViewController(config: .init(type: .location))
        searchVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            locationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }
    
    deinit {
        print("Location: Deinit")
    }
}

// MARK: - RMLocationViewViewModelDelegate
extension RMLocationViewController: RMLocationViewViewModelDelegate {
    func didLoadMoreLocations(with nextIndex: [IndexPath]) {
        self.locationView.tableView.performBatchUpdates { [weak self] in
            self?.locationView.tableView.insertRows(at: nextIndex, with: .automatic)
        }
    }
    
    func didLoadInitialLocations() {
        self.locationView.configure(with: self.viewModel)
    }
}

// MARK: - tableView dataSource
extension RMLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = viewModel.locationCellViewModels[indexPath.row]
        cellViewModel.delegate = cell
        cellViewModel.loadCell()
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RMTableViewLoadingFooterView.footerIdentifier) as? RMTableViewLoadingFooterView
        
        return footer
    }
}

// MARK: - tableView delegate
extension RMLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = RMLocationDetailViewViewModel(location: viewModel.locationArray[indexPath.row])
        let detailVC = RMLocationDetailViewController(viewModel: model)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalContentSize = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        let offset = scrollView.contentOffset.y
        
        
        if offset >= (totalContentSize - scrollViewHeight) {
            if viewModel.isLoading == false {
                self.viewModel.fetchMoreLocations()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard viewModel.shouldShowSpinner == true, viewModel.isLoading == true else {
            return 0
        }
            return 50
    }
}
