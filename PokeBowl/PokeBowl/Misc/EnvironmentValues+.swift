//
//  EnvironmentValues+.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import SwiftUI

private struct ViewModelProviderEnvironmentKey: EnvironmentKey {
    static var defaultValue: ViewModelProvider = ViewModelProvider()
}

extension EnvironmentValues {
    var viewModelProvider: ViewModelProvider {
        get { self[ViewModelProviderEnvironmentKey.self] }
        set { self[ViewModelProviderEnvironmentKey.self] = newValue }
    }
}
