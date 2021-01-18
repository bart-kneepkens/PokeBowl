//
//  GenerationPickerViewModelTests.swift
//  PokeBowlTests
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import XCTest
@testable import PokeBowl

class GenerationPickerViewModelTests: XCTestCase {
    var mockSpecies: [PokemonSpecies] {
        [.init(name: "charmander", url: ""), .init(name: "bulbasaur", url: ""), .init(name: "squirtle", url: "")]
    }
    
    var mockGeneration: Generation {
        Generation(name: "test-generation", pokemonSpecies: self.mockSpecies)
    }
    
    func testGenerationsFetching() {
        let expectation = self.expectation(description: "Provider.fetchGenerations gets called exactly once")
        expectation.expectedFulfillmentCount = 1
        
        let provider = MockGenerationProvider(generations: [mockGeneration]) {
            expectation.fulfill()
        }
        
        let viewModel = GenerationPickerViewModel(generationProvider: provider)
        
        guard case .initial = viewModel.state else {
            XCTFail()
            return
        }
        
        viewModel.fetchGenerations()
        
        guard case .loading = viewModel.state else {
            XCTFail()
            return
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testState() {
        let provider = MockGenerationProvider(generations: [mockGeneration])
        let viewModel = GenerationPickerViewModel(generationProvider: provider)
        
        // Should start as .initial
        guard case .initial = viewModel.state else {
            XCTFail()
            return
        }
        
        // Should go to .loading after fetch is called
        viewModel.fetchGenerations()
        guard case .loading = viewModel.state else {
            XCTFail()
            return
        }
        
        // Should go to .loaded at some point in time
        let expectation = self.expectation(description: "Goes to .loaded")
        let disposable = viewModel.$state.sink { state in
            if case .loaded(let generations) = state {
                if generations == [self.mockGeneration] {
                    expectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
}
