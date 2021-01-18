//
//  URLSession+.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation

protocol NetworkSession {
    func publisher(for request: URLRequest) -> DataResponsePublisher
}

extension URLSession: NetworkSession {
    func publisher(for request: URLRequest) -> DataResponsePublisher {
        return self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
