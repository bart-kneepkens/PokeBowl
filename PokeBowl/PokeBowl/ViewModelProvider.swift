//
//  ViewModelProvider.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation

class ViewModelProvider {
    private let generationProvider: GenerationProvider
    private let pokemonProvider: PokemonProvider
    
    init() {
        let pokeAPI = PokeAPI(session: URLSession.shared)
        self.generationProvider = APIGenerationProvider(api: pokeAPI)
        self.pokemonProvider = APIPokemonProvider(api: pokeAPI)
    }
}

extension ViewModelProvider {
    var generationPickerViewModel: GenerationPickerViewModel {
        .init(generationProvider: generationProvider)
    }
}

extension ViewModelProvider {
    func whoIsThatPokemonViewModel(with generation: Generation) -> WhoIsThatPokemonViewModel {
        .init(generation: generation, pokemonProvider: pokemonProvider)
    }
}
