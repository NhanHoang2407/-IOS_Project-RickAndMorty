//
//  ImgLoader.swift
//  RickAndMorty
//
//  Created by Nhan Hoang on 19/2/25.
//  Copyright © 2025 IC DEV. All rights reserved.
//

import Foundation
import Alamofire

final class ImgLoader {
    static let shared = ImgLoader()
    
    private init(){}
    
    func loadImg(url: URL, completion: @escaping(Result<Data, APIError>)->Void) {
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("Can't download character's image.")
                    completion(.failure(.noData))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure:
                print("Can't download character's image.")
                completion(.failure(.noData))
            }
        }
    }
}
