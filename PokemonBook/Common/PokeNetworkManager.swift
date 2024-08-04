//
//  PokeNetworkManager.swift
//  PokemonBook
//
//  Created by 머성이 on 8/4/24.
//

import Foundation
import RxSwift

// 에러 타입설정
enum NetworkError: Error {
    case invalidURL
    case dataFetchFail
    case decodingFail
}

class PokeNetworkManager {
    static let shared = PokeNetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let session = URLSession(configuration: .default)
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let data = data,
                      let response = response as?HTTPURLResponse,(200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                
                do {
                    let decodeedData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodeedData))
                } catch {
                    observer(.failure(NetworkError.decodingFail))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
