//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 7/3/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit
protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String)
    func rmSearchInputView(_ inputView: RMSearchInputView, searchButtonClicked searchBar: UISearchBar)
}

class RMSearchInputView: UIView {
    private var debounceDispatchWorkItem: DispatchWorkItem?
    private let timeInterval: DispatchTimeInterval = .milliseconds(300)
    
    public let viewModel: RMSearchInputViewViewModel
    
    weak var delegate: RMSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search"
        return search
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        view.alignment = .center
        return view
    }()
    
    init(frame: CGRect, viewModel: RMSearchInputViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        viewModel.delegate = self
        self.addSubview(searchBar)
        searchBar.delegate = self
        self.addSubview(stackView)
        createStackViewOptions(options: viewModel.options)
        self.translatesAutoresizingMaskIntoConstraints = false
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.becomeFirstResponder()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            stackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createStackViewOptions(options: [RMSearchInputViewViewModel.DynamicOptions]) {
        if viewModel.shouldHaveDynamicOptions == true {
            for option in options {
                let button = createButton(option: option)
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    private func createButton(option: RMSearchInputViewViewModel.DynamicOptions) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(option.rawValue, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(optionDidTap), for: .touchUpInside)
        button.tag = option.buttonTag
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 5
        return button
    }
    
    @objc func optionDidTap(_ sender: UIButton) {
        let options = viewModel.options
        for option in options {
            if option.buttonTag == sender.tag {
                delegate?.rmSearchInputView(self, didSelectOption: option)
            }
        }
    }
}

// searchBar Delegate
extension RMSearchInputView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounceDispatchWorkItem?.cancel()
        let newDispatchWorkItem = DispatchWorkItem { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.rmSearchInputView(weakSelf, searchButtonClicked: searchBar)
        }
        debounceDispatchWorkItem = newDispatchWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: newDispatchWorkItem)
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.rmSearchInputView(self, searchButtonClicked: searchBar)
    }
}

// viewModel delegate
extension RMSearchInputView: RMSearchInputViewViewModelDelegate {
    func updateButtonTitle(option: RMSearchInputViewViewModel.DynamicOptions, title: String) {
        let buttons = stackView.arrangedSubviews
        for button in buttons {
            guard let button = button as? UIButton else {
                return
            }
            if button.tag == option.buttonTag {
                button.setTitle(title, for: .normal)
                button.setTitleColor(.systemBlue, for: .normal)
            }
        }
    }
}
