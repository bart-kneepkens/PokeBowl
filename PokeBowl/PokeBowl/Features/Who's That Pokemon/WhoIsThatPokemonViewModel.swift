//
//  WhoIsThatPokemonViewModel.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import Foundation
import Combine

class WhoIsThatPokemonViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case playing(Pokemon)
        case played
    }
    
    @Published var shouldShowPokemon: Bool = false
    @Published var state: State = .initial
    var options: [String] = []
    
    var totalNumberOfPokemon: Int { generation.pokemonSpecies.count }
    
    var numberOfPokemonCompleted: Int { completedPokemonNames.count }
    
    private var generation: Generation
    private var cancellable: AnyCancellable? = nil
    private var pokemonProvider: PokemonProvider
    private var completedPokemonNames: [String] = []
    
    private var currentPokemon: Pokemon? {
        if case .playing(let pokemon) = self.state {
            return pokemon
        }
        return nil
    }
    
    init(generation: Generation, pokemonProvider: PokemonProvider) {
        self.pokemonProvider = pokemonProvider
        self.generation = generation
        self.setupNextPokemon()
    }
    
    func fetchPokemon() {
        guard case .initial = state else { return }
        
        self.state = .loading
        
        guard let pokemonName = self.options.randomElement() else { return }
        
        self.cancellable = self.pokemonProvider
            .fetchPokemon(by: pokemonName)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { result in }, receiveValue: { pokemon in
                if let pokemon = pokemon {
                    self.state = .playing(pokemon)
                }
            })
    }
    
    func answer(with option: String) {
        if option == self.currentPokemon?.name {
            self.shouldShowPokemon = true
            self.completedPokemonNames.append(option)
            
            // Prepare the next pokemon to be guessed, but only after 1 second
            // This allows the user to actually see the image of their correct answer
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.state = .initial
                self.setupNextPokemon()
                self.fetchPokemon()
                self.shouldShowPokemon = false
            }
        }
    }
    
    private func setupNextPokemon() {
        let speciesNames = Set<String>(generation.pokemonSpecies.map({ $0.name }).filter({ !self.completedPokemonNames.contains($0) }))
        let randomSpecies = speciesNames.randomUniqueElements(amount: 3)
        self.options = randomSpecies
    }
}
