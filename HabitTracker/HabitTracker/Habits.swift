//
//  Habits.swift
//  HabitTracker
//
//  Created by Ma Xueyuan on 2019/11/26.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

class Habits: ObservableObject {
    @Published var items = [Habit]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items")
        {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([Habit].self, from: items) {
                self.items = decoded
                return
            }
        }
        
        self.items = []
    }
}
