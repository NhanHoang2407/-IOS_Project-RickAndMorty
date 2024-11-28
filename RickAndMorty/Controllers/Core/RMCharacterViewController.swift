//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by IC DEV on 11/27/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import UIKit

final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters"
        view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
        
        let request = RMRequest(endPoint: .location, pathComponents: ["character", "hello"], queryParameters: [URLQueryItem(name: "status", value: "alive")])
        print(request.urlString)
    }

}
