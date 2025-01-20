//
//  Result.swift
//  RickAndMorty
//
//  Created by IC DEV on 12/2/24.
//  Copyright © 2024 IC DEV. All rights reserved.
//

import Foundation
enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}

