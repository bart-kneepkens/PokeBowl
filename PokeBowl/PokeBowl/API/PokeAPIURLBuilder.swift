//
//  PokeAPIURLBuilder.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 14/01/2021.
//

import Foundation

fileprivate let API_HOST = "https://pokeapi.co"
fileprivate let API_VERSION = 2

struct PokeAPIURLBuilder {
    enum Endpoint: String {
        case pokemon
        case generation
    }
    
    private static let baseURLString = "\(API_HOST)/api/v\(API_VERSION)/"
    private static var baseURLComponents: URLComponents? {
        URLComponents(string: baseURLString)
    }
    
    static func build(for endpoint: Endpoint, with parameter: String = "") -> URL? {
        guard var baseComponents = self.baseURLComponents else { return nil }
        baseComponents.path.append("\(endpoint)/\(parameter)")
        return baseComponents.url
    }
}
