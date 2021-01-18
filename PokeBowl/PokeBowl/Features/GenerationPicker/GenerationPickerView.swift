//
//  GenerationPickerView.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import SwiftUI
import Combine

struct GenerationPickerView: View {
    @Environment(\.viewModelProvider) var viewModelProvider: ViewModelProvider
    @ObservedObject var viewModel: GenerationPickerViewModel
    
    @ViewBuilder private func generationsSections(for generationResults: [Generation]) -> some View {
        Section {
            ForEach(generationResults, id: \.name) { generation in
                NavigationLink(
                    destination: WhoIsThatPokemonView(viewModel: viewModelProvider.whoIsThatPokemonViewModel(with: generation)),
                    label: {
                        Text(generation.prettyName)
                    })
                    .buttonStyle(PressablePokedexButtonStyle())
                    .padding(.horizontal)
                    .frame(height: 44)
            }
        }
    }
    
    @ViewBuilder private var contents: some View {
        switch self.viewModel.state {
        case .loaded(let generations):
            self.generationsSections(for: generations)
        default: ProgressView()
        }
    }
    
    var body: some View {
        ZStack {
            Color("PokedexRed").edgesIgnoringSafeArea(.all)
            VStack {
                Image("WhosThatPokemonText")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                contents
                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                self.viewModel.fetchGenerations()
            }
        }
    }
}

struct GenerationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GenerationPickerView(viewModel: .init(generationProvider: APIGenerationProvider(api: PokeAPI(session: URLSession.shared))))
        }
    }
}
