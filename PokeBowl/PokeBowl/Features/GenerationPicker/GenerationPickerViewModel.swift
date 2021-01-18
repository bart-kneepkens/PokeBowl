//
//  GenerationPickerViewModel.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation
import Combine

class GenerationPickerViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case loaded([Generation])
        case error(PokeAPI.PokeAPIError)
    }
    
    @Published var state: State = .initial
    private var disposable: AnyCancellable? = nil
    private var generationProvider: GenerationProvider
    
    init(generationProvider: GenerationProvider) {
        self.generationProvider = generationProvider
        self.disposable = generationProvider
            .generations
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in }, receiveValue: { generations in
                if !generations.isEmpty {
                    self.state = .loaded(generations.sorted(by: { $0.name < $1.name }))
                }
            })
    }
    
    func fetchGenerations() {
        guard case .initial = self.state else { return }
        self.generationProvider.fetchAllGenerations()
        self.state = .loading
    }
}
