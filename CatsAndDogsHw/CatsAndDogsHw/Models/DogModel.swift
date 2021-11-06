//
//  DogModel.swift
//  CatsAndDogsHw
//
//  Created by Rishat on 06.11.2021.
//

import Foundation

//MARK: - DogModel

struct Dog: Decodable {

    let message: String?

    init(message: String? = nil) {
        self.message = message
    }
    
}
