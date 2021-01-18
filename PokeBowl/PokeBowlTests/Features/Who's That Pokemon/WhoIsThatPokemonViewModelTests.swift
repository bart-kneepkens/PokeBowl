//
//  WhoIsThatPokemonViewModelTests.swift
//  PokeBowlTests
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import XCTest
@testable import PokeBowl

class WhoIsThatPokemonViewModelTests: XCTestCase {
    
    var mockSpecies: [PokemonSpecies] {
        [.init(name: "charmander", url: ""), .init(name: "bulbasaur", url: ""), .init(name: "squirtle", url: "")]
    }
    
    var mockGeneration: Generation {
        Generation(name: "test-generation", pokemonSpecies: self.mockSpecies)
    }
    
    var mockPokemon: Pokemon {
        .init(id: 1337, name: "charmander", sprites: .init())
    }
    
    func testGameInitialization() {
        // When a viewmodel is initialized with a Generation object, it should set its options to exactly 3 of the names list in Generation.pokemonspecies.
        let viewModel = WhoIsThatPokemonViewModel(generation: self.mockGeneration, pokemonProvider: MockPokemonProvider())
        
        XCTAssertEqual(viewModel.options.count, 3)
        
        viewModel.options.forEach { option in
            XCTAssert(self.mockGeneration.pokemonSpecies.contains(where: { $0.name == option }))
        }
    }
    
    func testPokemonFetching() {
        // Should call provider for a random pokemon name (from the generation passed in)
        let generation = self.mockGeneration
        
        let expectation = self.expectation(description: "Provider gets called once with name that exists in generation object")
        expectation.expectedFulfillmentCount = 1
        
        let provider = MockPokemonProvider(returnValue: mockPokemon) { parameter in
            if generation.pokemonSpecies.contains(where: { $0.name == parameter }) {
                expectation.fulfill()
            }
        }
        
        let viewModel = WhoIsThatPokemonViewModel(generation: generation, pokemonProvider:provider)
        viewModel.fetchPokemon()
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPokemonImageVisibilityInitial() {
        // In its initial state, the viewModel should not allow the pokemon image to be displayed 'originally'
        let viewModel = WhoIsThatPokemonViewModel(generation: self.mockGeneration, pokemonProvider: MockPokemonProvider())
        XCTAssertFalse(viewModel.shouldShowPokemon)
    }
    
    func testPokemonImageVisibilityAfterAnswering() {
        let expectation = self.expectation(description: "state is changed to .playing")
        
        let viewModel = WhoIsThatPokemonViewModel(generation: self.mockGeneration, pokemonProvider: MockPokemonProvider(returnValue: mockPokemon))
        let cancellable = viewModel.$state.sink { state in
            switch state {
            case .playing:
                expectation.fulfill()
            default: break
            }
        }
        
        // View.OnAppear
        viewModel.fetchPokemon()
        
        // Should still hide the image
        XCTAssertFalse(viewModel.shouldShowPokemon)
        
        // Wait for state to be updated
        self.waitForExpectations(timeout: 2, handler: nil)
        
        // Answer Incorrectly
        viewModel.answer(with: "wrong answer")
        XCTAssertFalse(viewModel.shouldShowPokemon)
        
        // Answer correctly
        viewModel.answer(with: mockPokemon.name)
        XCTAssert(viewModel.shouldShowPokemon)
    }
}
