//
//  RMSettingViewController.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/27/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

final class RMSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }

    deinit {
        print("Setting: Deinit")
    }

}
