//
//  RMSettingViewController.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/27/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import StoreKit
import SafariServices
import UIKit

final class RMSettingViewController: UIViewController {
// MARK: Attribute
    let settingsView = RMSettingsView()
    let viewModel = RMSettingsViewViewModel(cellViewModels: SettingCatagory.allCases.compactMap({ catagory in
        return RMSettingsCellViewModel(settingType: catagory)
    }))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        view.backgroundColor = UIColor.tertiarySystemGroupedBackground
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
        self.view.addSubview(settingsView)
        addConstraint()
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            settingsView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            settingsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

        ])
    }

    deinit {
        print("Setting: Deinit")
    }

}
// MARK: TableView DataSource
extension RMSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMSettingsTableViewCell.cellIdentifier, for: indexPath) as? RMSettingsTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = viewModel.cellViewModels[indexPath.row]

        cell.configure(with: cellViewModel)
        return cell
    }
}
// MARK: TableView Delegate
extension RMSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        guard let targetURL = cellViewModel.settingsCatagoryURL else {
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            else {
                SKStoreReviewController.requestReview()
            }
            return
        }
        let vc = SFSafariViewController(url: targetURL)
        present(vc, animated: true)
    }
}
