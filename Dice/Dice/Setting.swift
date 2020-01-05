//
//  Setting.swift
//  Dice
//
//  Created by Ma Xueyuan on 2020/01/05.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

struct Setting: Codable {
    var sides: Int
    var dices: Int
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "setting")
        {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode(Setting.self, from: data) {
                self = decoded
                return
            }
        }
        
        sides = 6
        dices = 3
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: "setting")
        }
    }
}
