//
//  MockPokemonProvider.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation
import Combine

class MockPokemonProvider: PokemonProvider {
    
    private let returnValue: Pokemon?
    private let returnError: PokeAPI.PokeAPIError?
    private let onFetchCalled: ((String) -> Void)?
    
    init(returnValue: Pokemon? = nil, returnError: PokeAPI.PokeAPIError? = nil, onFetchCalled: ((String) -> Void)? = nil) {
        self.returnValue = returnValue
        self.returnError = returnError
        self.onFetchCalled = onFetchCalled
    }
    
    func fetchPokemon(by nameOrId: String) -> AnyPublisher<Pokemon?, PokeAPI.PokeAPIError> {
        onFetchCalled?(nameOrId)
        
        if let returnError = self.returnError {
            return Fail(error: returnError).eraseToAnyPublisher()
        }
        
        return Just(self.returnValue).mapError({ _ in PokeAPI.PokeAPIError.timedOut }).eraseToAnyPublisher()
        
    }
}
