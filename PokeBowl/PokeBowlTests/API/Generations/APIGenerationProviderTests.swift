//
//  APIGenerationProviderTests.swift
//  PokeBowlTests
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import XCTest
import Combine
@testable import PokeBowl

class APIGenerationProviderTests: XCTestCase {
    
    func testGoodWeatherResponse() {
        let provider = APIGenerationProvider(api: PokeAPI(session: MockSession(responses: [
            generationsCallResponse,
            generationResponse(name: "generation-i"),
            generationResponse(name: "generation-ii")
        ])))
        
        let expectation = self.expectation(description: "Did properly request and parse objects")
        
        provider.fetchAllGenerations()
        
        let cancellable = provider.generations.sink { comp in } receiveValue: { generations in
            if generations == [self.expectedGeneration(name: "generation-i"), self.expectedGeneration(name: "generation-ii")] {
                expectation.fulfill()
            }
        }

        self.waitForExpectations(timeout: 2, handler: nil)
    }
}

// Test utilities
extension APIGenerationProviderTests {
    class MockSession: NetworkSession {
        var calledURLs: [String] = []
        private let responses: [String]
        private var counter = 0
        
        init(responses: [String]) {
            self.responses = responses
        }
        
        func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
            self.calledURLs.append(request.url?.absoluteString ?? "")
            let data = responses[counter].data(using: .utf8)!
            counter += 1
            
            return Just((data: data, response: URLResponse()))
                .mapError({ _ in URLError(URLError.Code.cancelled )})
                .eraseToAnyPublisher()
        }
    }
    
    private var generationsCallResponse: String {
        """
        {
            "count": 8,
            "next": null,
            "previous": null,
            "results": [
                {
                    "name": "generation-i",
                    "url": "https://pokeapi.co/api/v2/generation/1/"
                },
                {
                    "name": "generation-ii",
                    "url": "https://pokeapi.co/api/v2/generation/2/"
                }
            ]
        }
        """
    }
    
    private func generationResponse(name: String) -> String {
        """
        {
            "name": "\(name)",
            "pokemon_species": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon-species/1/"
                },
                {
                    "name": "charmander",
                    "url": "https://pokeapi.co/api/v2/pokemon-species/4/"
                }
            ]
        }
        """
    }
    
    private func expectedGeneration(name: String) -> Generation {
        .init(name: name, pokemonSpecies: [
            .init(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
            .init(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon-species/4/"),
        ])
    }
}
