//
//  PokemonSprites.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import Foundation

struct PokemonSprites: Decodable {
    let frontDefault: String
    let officialArtwork: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault
        case other
    }
    
    enum OtherCodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
    
    enum OfficialArtworkCodingKeys: String, CodingKey {
        case frontDefault
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.frontDefault = try values.decode(String.self, forKey: CodingKeys.frontDefault)
        let other = try values.nestedContainer(keyedBy: OtherCodingKeys.self, forKey: CodingKeys.other)
        let officialArtwork = try other.nestedContainer(keyedBy: OfficialArtworkCodingKeys.self, forKey: OtherCodingKeys.officialArtwork)
        self.officialArtwork = try officialArtwork.decode(String.self, forKey: OfficialArtworkCodingKeys.frontDefault)
    }
    
    init() {
        self.frontDefault = ""
        self.officialArtwork = ""
    }
}

struct PokemonSpritesOther: Codable {
    let officialArtwork: PokemonSpritesOfficialArtwork?
}

struct PokemonSpritesOfficialArtwork: Codable {
    let frontDefault: String?
}
