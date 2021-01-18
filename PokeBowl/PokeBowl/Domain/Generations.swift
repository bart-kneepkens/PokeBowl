//
//  Generations.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import Foundation

struct Generations {
    let results: [GenerationResult]
}

extension Generations: Decodable {}

struct GenerationResult {
    let name: String
    let url: String
}

extension GenerationResult: Decodable {}
