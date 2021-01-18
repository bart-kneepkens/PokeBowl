//
//  APIPokemonProvider.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation
import Combine

class APIPokemonProvider: PokemonProvider {
    private let api: PokeAPI
    
    init(api: PokeAPI) {
        self.api = api
    }
    
    func fetchPokemon(by nameOrId: String) -> AnyPublisher<Pokemon?, PokeAPI.PokeAPIError> {
        api.fetchPokemon(nameOrId)
    }
}
