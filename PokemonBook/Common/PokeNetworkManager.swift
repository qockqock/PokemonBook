//
//  PokeNetworkManager.swift
//  PokemonBook
//
//  Created by 머성이 on 8/4/24.
//

import Foundation
import RxSwift
import UIKit

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
    
    //MARK: -포켓몬 이미지 가져오는 메서드
    func fetchImage(id: Int) -> Single<UIImage?> {
            let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
            
            guard let url = URL(string: urlString) else {
                return Single.just(nil)
            }
        
            return Single.create { single in
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                single(.success(image))
                            } else {
                                single(.success(nil))
                            }
                        }
                    } else {
                        single(.success(nil))
                    }
                }
                
                return Disposables.create()
            }
        }
}
