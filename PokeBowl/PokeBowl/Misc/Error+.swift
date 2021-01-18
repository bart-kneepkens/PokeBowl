//
//  Error+.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation

extension Error {
    typealias PokeAPIError = PokeAPI.PokeAPIError
    
    var asAPIError: PokeAPIError {
        if let apiError = self as? PokeAPIError {
            return apiError
        }
        if (self as NSError).code == NSURLErrorNotConnectedToInternet {
            return PokeAPIError.connectionIssues
        }
        if (self as NSError).code == NSURLErrorTimedOut {
            return PokeAPIError.timedOut
        }
        return PokeAPIError.unknown(self)
    }
}
