//
//  DataManager.swift
//  CatsAndDogsHw
//
//  Created by Rishat on 06.11.2021.
//

import UIKit
import Combine

//MARK: - API Service

class DataManager {

    private let catUrl = "https://catfact.ninja/fact"

    var catPublisher: AnyPublisher<Cat, Error> {
        let url = URL(string: catUrl)!

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Cat.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}

