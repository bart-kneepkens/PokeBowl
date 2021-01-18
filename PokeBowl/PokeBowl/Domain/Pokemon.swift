//
//  Pokemon.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 14/01/2021.
//

import Foundation

struct Pokemon {
    let id: Int
    let name: String
    let sprites: PokemonSprites
}

extension Pokemon: Decodable {}
