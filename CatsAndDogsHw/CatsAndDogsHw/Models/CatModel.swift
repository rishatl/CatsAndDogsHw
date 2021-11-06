//
//  CatModel.swift
//  CatsAndDogsHw
//
//  Created by Rishat on 06.11.2021.
//

import Foundation

//MARK: - CatModel

struct Cat: Decodable {

    let fact: String?

    init(fact: String? = nil) {
        self.fact = fact
    }
    
}
