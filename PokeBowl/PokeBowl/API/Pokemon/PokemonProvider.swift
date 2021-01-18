//
//  PokemonProvider.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation
import Combine

protocol PokemonProvider {
    func fetchPokemon(by nameOrId: String) -> AnyPublisher<Pokemon?, PokeAPI.PokeAPIError>
}
