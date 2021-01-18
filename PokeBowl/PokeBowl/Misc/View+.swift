//
//  View+.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    @inlinable public func monospaced() -> some View {
        return self.font(Font(UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)))
    }
}
