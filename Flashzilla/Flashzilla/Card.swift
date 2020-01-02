//
//  Card.swift
//  Flashzilla
//
//  Created by Ma Xueyuan on 2019/12/31.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String

    static var example: Card {
        return Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}
