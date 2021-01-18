//
//  APIGenerationProvider.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation
import Combine

class APIGenerationProvider: GenerationProvider {
    var generations = CurrentValueSubject<[Generation], Error>([])
    private var accumulatedGenerations: [Generation] = []
    private var cancellables: [AnyCancellable?] = []
    private let api: PokeAPI
    
    init(api: PokeAPI) {
        self.api = api
    }
    
    func fetchAllGenerations() {
        self.cancellables.append(
            api.fetchGenerationNames()
                .sink(receiveCompletion: { completion in }, receiveValue: { names in
                    if let names = names {
                        names.forEach { name in
                            self.fetchGeneration(with: name)
                        }
                    }
                })
        )
    }
    
    private func fetchGeneration(with name: String) {
        self.cancellables.append(
            api.fetchGeneration(for: name)
                .sink(receiveCompletion: { completion in
                self.generations.value = self.accumulatedGenerations
            }, receiveValue: { generation in
                if let generation = generation {
                    self.accumulatedGenerations.append(generation)
                }
            })
        )
    }
}
