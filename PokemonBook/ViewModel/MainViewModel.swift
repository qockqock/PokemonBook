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
    private var offset = 0
    private var isFetching = false
    
    init() {
        fetchPokeInfomation()
    }
    
    func fetchPokeInfomation() {
        guard !isFetching else { return }
        isFetching = true
        
        // 잘못된 URL인 경우 에러 방출
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokeInfoSubject.onError(NetworkError.invalidURL)
            print("유효하지 않음")
            return
        }
         
        PokeNetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokeResponse: PokeResponse) in
                guard let self = self else { return }
                self.offset += self.limit
                self.isFetching = false
                
                var currentResults = try? self.pokeInfoSubject.value()
                currentResults?.append(contentsOf: pokeResponse.results)
                self.pokeInfoSubject.onNext(currentResults ?? [])
            }, onFailure: { [weak self] error in
                self?.pokeInfoSubject.onError(error)
                self?.isFetching = false
            }).disposed(by: disposeBag)
    }
}
