//
//  SettingCatagory.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 25/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import UIKit

enum SettingCatagory: CaseIterable {
    case rate
    case contact
    case service
    case privacy
    case apiReference
    case videoSeries
    case appCode
    
    public var title: String {
        switch self {
        case .rate:
            return "Rate App"
        case .contact:
            return "Contact Us"
        case .service:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .videoSeries:
            return "View Video Series"
        case .appCode:
            return "View App Code"
        }
    }
    
    public var iconImg: UIImage? {
        switch self {
        case .rate:
            return UIImage(systemName: "star.fill")
        case .contact:
            return UIImage(systemName: "paperplane.fill")
        case .service:
            return UIImage(systemName: "document.fill")
        case .privacy:
            return UIImage(systemName: "lock.fill")
        case .apiReference:
            return UIImage(systemName: "list.bullet.rectangle.fill")
        case .videoSeries:
            return UIImage(systemName: "tv.fill")
        case .appCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    public var iconBackgroundColor: UIColor {
        switch self {
        case .rate:
            return UIColor.systemBlue
        case .contact:
            return UIColor.systemYellow
        case .service:
            return UIColor.systemGray
        case .privacy:
            return UIColor.systemGreen
        case .apiReference:
            return UIColor.systemRed
        case .videoSeries:
            return UIColor.systemOrange
        case .appCode:
            return UIColor.systemPink
        }
    }
    
    public var settingCatagoryURL: URL? {
        switch self {
        case .rate:
            return nil
        case .contact:
            return URL(string: "https://iosacademy.io")
        case .service:
            return URL(string:  "https://iosacademy.io/terms")
        case .privacy:
            return URL(string:  "https://iosacademy.io/privacy")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation/#get-a-single-episode")
        case .videoSeries:
            return URL(string: "https://www.youtube.com/playlist?list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y")
        case .appCode:
            return URL(string: "https://github.com/NhanHoang2407/-IOS_Project-RickAndMorty")
        }
    }
}
