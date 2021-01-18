//
//  Set+.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import Foundation

extension Set {
    func randomUniqueElements(amount: Int) -> [Element] {
        guard amount > 0, self.count >= amount else { return [] }
        var remainder = self
        var results: [Element] = []
        
        (0..<amount).forEach { _ in
            guard let value = self.randomElement() else { return }
            results.append(value)
            remainder.remove(value)
        }
        
        return results
    }
}
