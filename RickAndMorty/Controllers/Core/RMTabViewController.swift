//
//  ViewController.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/27/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

final class RMTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupTabs()
    }

    private func setupTabs() {
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingVC = RMSettingViewController()
        
        
        let nv1 = UINavigationController(rootViewController: characterVC)
        let nv2 = UINavigationController(rootViewController: locationVC)
        let nv3 = UINavigationController(rootViewController: episodeVC)
        let nv4 = UINavigationController(rootViewController: settingVC)
        
        nv1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(named: "character"), tag: 1)
        nv2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(named: "location"), tag: 2)
        nv3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(named: "episode"), tag: 3)
        nv4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "setting"), tag: 4)
        
        for nav in [nv1, nv2, nv3, nv4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nv1, nv2, nv3, nv4],
            animated: true)
    }


}

