//
//  Generation.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import Foundation

struct Generation {
    let name: String
    let pokemonSpecies: [PokemonSpecies]
}

extension Generation: Decodable, Equatable {}

extension Generation {
    var prettyName: String {
        // generation names are in the format of `generation-iii`
        guard self.name.contains("generation-"), let index = self.name.firstIndex(of: "-") else { return self.name }
        return "Generation \(self.name.suffix(from: self.name.index(after: index)).uppercased())"
    }
}

struct PokemonSpecies {
    let name: String
    let url: String
}

extension PokemonSpecies: Decodable, Equatable {}
