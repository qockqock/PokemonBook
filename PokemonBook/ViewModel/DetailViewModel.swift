//
//  DetailViewModel.swift
//  PokemonBook
//
//  Created by 머성이 on 8/6/24.
//

import Foundation
import RxSwift

class DetailViewModel {

    private let disposeBag = DisposeBag()
    private let pokemonID: String
    let pokeDetailSubject = PublishSubject<DetailInfo>()
    
    // pokeDetail을 Observable로 제공
    var pokeDetail: Observable<DetailInfo> {
        return pokeDetailSubject.asObservable()
    }

    init(pokemonID: String) {
        self.pokemonID = pokemonID
        fetchPokeDetail()
    }
    
    func fetchPokeDetail() {
        // 잘못된 URL인 경우 에러 방출
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)") else {
            pokeDetailSubject.onError(NetworkError.invalidURL)
            print("유효하지 않음")
            return
        }
         
        PokeNetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokeResponse: DetailInfo) in
                self?.pokeDetailSubject.onNext(pokeResponse)
            }, onFailure: { [weak self] error in
                self?.pokeDetailSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
