//
//  Habit.swift
//  HabitTracker
//
//  Created by Ma Xueyuan on 2019/11/26.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    var completeTimes: Int
}
