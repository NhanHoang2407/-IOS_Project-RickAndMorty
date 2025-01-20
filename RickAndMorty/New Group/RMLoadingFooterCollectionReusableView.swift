//
//  RMLoadingFooterCollectionReusableView.swift
//  RickAndMorty
//
//  Created by IC DEV on 1/16/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

class RMLoadingFooterCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "RMLoadingFooterCollectionReusableView"
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(spinner)
        setUpUI()
        spinner.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // loading spinner appearing before data fetched
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func setUpUI() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
    }
}
