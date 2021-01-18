//
//  PokeAPI.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 14/01/2021.
//

import Foundation
import Combine

struct PokeAPI {
    enum PokeAPIError: Error {
        case notFound
        case timedOut
        case connectionIssues
        case urlBuilding
        case unknown(Error)
    }
    
    private let session: NetworkSession
    
    init(session: NetworkSession) {
        self.session = session
    }
    
    func fetchPokemon(_ nameOrId: String) -> AnyPublisher<Pokemon?, PokeAPIError> {
        guard let url = PokeAPIURLBuilder.build(for: .pokemon, with: nameOrId) else {
            return Fail(error: PokeAPIError.urlBuilding).eraseToAnyPublisher()
        }
        
        return PokeAPIRequest(url: url, session: self.session)
            .publisher
            .map { dataResponse -> Pokemon? in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try? decoder.decode(Pokemon.self, from: dataResponse.data)
            }
            .eraseToAnyPublisher()
    }
}

extension PokeAPI {
    func fetchGenerationNames() -> AnyPublisher<[String]?, PokeAPIError> {
        guard let url = PokeAPIURLBuilder.build(for: .generation) else {
            return Fail(error: PokeAPIError.urlBuilding).eraseToAnyPublisher()
        }
        
        return PokeAPIRequest(url: url, session: self.session)
            .publisher
            .map { dataResponse -> Generations? in
                let decoder = JSONDecoder()
                return try? decoder.decode(Generations.self, from: dataResponse.data)
            }
            .compactMap({ $0?.results.map({ $0.name }) })
            .eraseToAnyPublisher()
    }
    
    func fetchGeneration(for generationName: String) -> AnyPublisher<Generation?, PokeAPIError> {
        guard let url = PokeAPIURLBuilder.build(for: .generation, with: generationName) else {
            return Fail(error: PokeAPIError.urlBuilding).eraseToAnyPublisher()
        }
        
        return PokeAPIRequest(url: url, session: self.session)
            .publisher
            .map { dataResponse -> Generation? in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try? decoder.decode(Generation.self, from: dataResponse.data)
            }
            .eraseToAnyPublisher()
    }
}
