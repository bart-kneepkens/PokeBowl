//
//  WhoIsThatPokemonView.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import SwiftUI

fileprivate let defaultCornerRadius: CGFloat = 10

struct WhoIsThatPokemonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel: WhoIsThatPokemonViewModel
    
    @ViewBuilder private var topBar: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left").foregroundColor(.white)
            }
            Spacer()
            HStack(alignment: .top) {
                light(color: .blue)
                light(color: .yellow)
                light(color: .green)
            }
        }
    }
    
    @ViewBuilder private var buttons: some View {
        VStack {
            ForEach(self.viewModel.options, id: \.self) { option in
                Button(option.capitalized) {
                    self.viewModel.answer(with: option)
                }
                .buttonStyle(PressablePokedexButtonStyle())
                .frame(height: 64)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color("PokedexRed").edgesIgnoringSafeArea(.all)
            VStack {
                topBar
                Spacer()
                pokedexScreen
                Spacer()
                buttons
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .onAppear {
                self.viewModel.fetchPokemon()
            }
        }
    }
}

// MARK: - Pokedex screen
extension WhoIsThatPokemonView {
    @ViewBuilder private var counter: some View {
        Text("\(self.viewModel.numberOfPokemonCompleted)/\(self.viewModel.totalNumberOfPokemon)")
            .monospaced()
            .padding(4)
            .background(Color.green)
            .border(Color.black, width: 2)
    }
    
    @ViewBuilder private var pokedexScreenContent: some View {
        if case .playing(let pokemon) = self.viewModel.state {
            CachedRemoteImage(url: URL(string: pokemon.sprites.officialArtwork), showsOriginal: $viewModel.shouldShowPokemon)
        } else {
            ProgressView()
        }
    }
    
    @ViewBuilder private var pokedexScreen: some View {
        ZStack {
            // Gray bezel
            RoundedRectangle(cornerRadius: defaultCornerRadius, style: .continuous)
                .foregroundColor(Color("PokedexGray"))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 2))
            
            VStack {
                // Center top two red lights
                HStack {
                    ForEach(0..<2) { _ in
                        light(color: .red, size: 10)
                    }
                }.padding(4)
                
                // content screen
                RoundedRectangle(cornerRadius: defaultCornerRadius)
                    .foregroundColor(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: defaultCornerRadius).strokeBorder(lineWidth: 2))
                    .overlay(pokedexScreenContent)
                
                // Bottom bezel contents
                HStack {
                    light(color: .red) // left red light
                    Spacer()
                    counter
                    Spacer()
                    VStack(spacing: 5) { // speaker
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: defaultCornerRadius)
                                .frame(width: 20, height: 5)
                        }
                    }
                }
            }.padding()
        }
        .aspectRatio(4/3, contentMode: .fit)
    }
}

// MARK: - Pokedex light
extension WhoIsThatPokemonView {
    @ViewBuilder private func light(color: Color, size: CGFloat = 25) -> some View {
        Circle()
            .foregroundColor(color)
            .frame(width: size, height: size)
            .overlay(Circle().strokeBorder(lineWidth: 2))
            .shadow(color: .gray, radius: 2, x: 1, y: 1)
    }
}

struct WhoIsThatPokemonView_Previews: PreviewProvider {
    static var previews: some View {
        WhoIsThatPokemonView(viewModel: .init(generation: Generation(name: "generation Z", pokemonSpecies: [.init(name: "Species 1", url: ""), .init(name: "Species 2", url: ""), .init(name: "Species 3", url: "")]), pokemonProvider: MockPokemonProvider(returnValue: Pokemon(id: 1337, name: "Pikachu", sprites: .init()))))
    }
}
