//
//  GenerationProvider.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 17/01/2021.
//

import Foundation
import Combine

protocol GenerationProvider {
    var generations: CurrentValueSubject<[Generation], Error> { get }
    func fetchAllGenerations()
}
