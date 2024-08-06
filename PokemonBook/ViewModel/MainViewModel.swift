//
//  MainViewModel.swift
//  PokemonBook
//
//  Created by 머성이 on 8/5/24.
//

import Foundation
import RxSwift

class MainViewModel {

    private let disposeBag = DisposeBag()
    
    // View가 구독할 subject
    let pokeInfoSubject = BehaviorSubject(value: [PokeInfo]())
    
    // 임의의 값 지정
    private let limit = 20
    private let offset = 0
    
    init() {
        fetchPokeInfomation()
    }
    
    func fetchPokeInfomation() {
        // 잘못된 URL인 경우 에러 방출
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokeInfoSubject.onError(NetworkError.invalidURL)
            print("유효하지 않음")
            return
        }
         
        PokeNetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokeResponse: PokeResponse) in
                self?.pokeInfoSubject.onNext(pokeResponse.results)
            }, onFailure: { [weak self] error in
                self?.pokeInfoSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
