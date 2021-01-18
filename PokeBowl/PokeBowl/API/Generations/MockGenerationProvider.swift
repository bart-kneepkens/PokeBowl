//
//  MockGenerationProvider.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation
import Combine

class MockGenerationProvider: GenerationProvider {
    private let mockGenerations: [Generation]
    private let onFetchCalled: (() -> Void)?
    
    init(generations: [Generation] = [], onFetchCalled: (() -> Void)? = nil) {
        self.mockGenerations = generations
        self.onFetchCalled = onFetchCalled
    }
    
    var generations = CurrentValueSubject<[Generation], Error>([])
    
    func fetchAllGenerations() {
        self.onFetchCalled?()
        self.generations.value = self.mockGenerations
    }
}
