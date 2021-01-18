//
//  ContentView.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 13/01/2021.
//

import SwiftUI

struct ContentView: View {
    let viewModelProvider = ViewModelProvider()
    
    var body: some View {
        NavigationView {
            GenerationPickerView(viewModel: viewModelProvider.generationPickerViewModel)
        }
        .environment(\.viewModelProvider, self.viewModelProvider)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
