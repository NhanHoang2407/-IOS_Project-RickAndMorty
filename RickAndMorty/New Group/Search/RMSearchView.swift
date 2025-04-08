//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 6/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)
    func rmSearchView<T: Codable>(_ searchView: RMSearchView, didSelectElement element: T)
}

class RMSearchView: UIView {
    private let viewModel: RMSearchViewViewModel
    private let noResultView: RMSearchNoResultView = RMSearchNoResultView()
    private let searchInputView: RMSearchInputView
    private let searchResultTable: RMSearchResultView = RMSearchResultView()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    weak var delegate: RMSearchViewDelegate?

    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        self.searchInputView = RMSearchInputView(frame: .zero, viewModel: viewModel.searchInputViewViewModel)
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false

        viewModel.registerSearchResultsHandler { [weak self] viewModel in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.noResultView.isHidden = true
                weakSelf.searchResultTable.configure(with: viewModel)
            }
        }
        viewModel.registerNoSearchResultsHandler { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.searchResultTable.isHidden = true
                weakSelf.noResultView.isHidden = false
            }
        }
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        addSubview(noResultView)
        addSubview(searchInputView)
        addSubview(searchResultTable)
        addSubview(spinner)
        searchInputView.delegate = self
        searchResultTable.delegate = self
        
        NSLayoutConstraint.activate([
            noResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultView.centerYAnchor.constraint(equalTo: centerYAnchor),
            noResultView.widthAnchor.constraint(equalToConstant: 150),
            noResultView.heightAnchor.constraint(equalToConstant: 150),
            
            searchInputView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 5),
            searchInputView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -5),
            searchInputView.heightAnchor.constraint(equalToConstant: searchInputView.viewModel.shouldHaveDynamicOptions ? 130: 70),
            
            searchResultTable.topAnchor.constraint(equalTo: searchInputView.bottomAnchor, constant: -10),
            searchResultTable.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 5),
            searchResultTable.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -5),
            searchResultTable.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            spinner.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),

        ])
    }
    
    public func showLoadingSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.spinner.startAnimating()
            weakSelf.noResultView.isHidden = true
            weakSelf.searchResultTable.isHidden = true
        }
    }
    public func hideLoadingSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.spinner.stopAnimating()
        }
    }
}

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.setSearchText(text: text)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, searchButtonClicked searchBar: UISearchBar) {
        viewModel.searchExecute(completion: hideLoadingSpinner)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
}

extension RMSearchView: RMSearchResultViewDelegate {
    func rmSearchResultView<T>(_ searchResultView: RMSearchResultView, didSelectElement element: T) where T : Decodable, T : Encodable {
        delegate?.rmSearchView(self, didSelectElement: element)
    }
}
