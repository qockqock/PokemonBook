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
    let url: String?
}

// 디테일은 1. No, 2. 이름, 3. 타입, 4. 키, 5. 몸무게
struct DetailInfo: Codable {
    let id: String?
    let types: [TypeElement]
    let height: Int?
    let weight: Int?
}

struct TypeElement: Codable {
    let slot: Int?
    let type: Species
}

struct Species: Codable {
    let name: String
}
