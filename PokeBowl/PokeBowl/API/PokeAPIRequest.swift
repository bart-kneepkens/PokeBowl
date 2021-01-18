//
//  PokeAPIRequest.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 14/01/2021.
//

import Foundation
import Combine

typealias DataResponse = (data: Data, response: URLResponse)
typealias DataResponsePublisher = AnyPublisher<DataResponse, URLError>

struct PokeAPIRequest {
    private let url: URL
    private let session: NetworkSession
    
    init(url: URL, session: NetworkSession = URLSession.shared) {
        self.url = url
        self.session = session
    }
    
    var publisher: AnyPublisher<DataResponse, PokeAPI.PokeAPIError> {
        session.publisher(for: URLRequest(url: self.url))
            .tryMap { output -> DataResponse in
                // TODO in future: Check here for possible HTTP status codes
                return output
            }
            .mapError({ error -> PokeAPI.PokeAPIError in
                error.asAPIError
            })
            .retry(2)
            .eraseToAnyPublisher()
    }
}
