//
//  PokeInfo.swift
//  PokemonBook
//
//  Created by 머성이 on 8/4/24.
//

import Foundation

struct PokeResponse: Codable {
    let results: [PokeInfo]
}

struct PokeInfo: Codable {
    let name: String?
    let url: String
    
    var id: Int {
        let separator = url.split(separator: "/")
        return Int(separator.last ?? "0") ?? 0
    }
}

// 디테일은 1. No, 2. 이름, 3. 타입, 4. 키, 5. 몸무게
struct DetailInfo: Codable {
    let id: Int?
    let name: String?
    let types: [TypeElement]
    let height: Float?
    let weight: Float?
}

struct TypeElement: Codable {
    let slot: Int?
    let type: Species
}

struct Species: Codable {
    let name: String?
}
