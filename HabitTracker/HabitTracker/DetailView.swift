//
//  DetailView.swift
//  HabitTracker
//
//  Created by Ma Xueyuan on 2019/11/26.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var habits: Habits
    @State var habit: Habit
    
    var body: some View {
        Form {
            Section(header: Text("Habit name")) {
                Text(habit.name)
            }
            Section(header: Text("Description")) {
                Text(habit.description)
            }
            Section(header: Text("Complete times")) {
                HStack {
                    Text("\(habit.completeTimes)")
                    Spacer()
                    Button("+1") {
                        self.habit.completeTimes += 1
                        if let firstIndex = self.habits.items.firstIndex(where: { (habit) -> Bool in
                            habit.id == self.habit.id
                        }) {
                            self.habits.items[firstIndex] = self.habit
                        }
                    }.padding(.trailing)
                }
            }
        }.navigationBarTitle("Habit Detail", displayMode: .inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(habits: Habits(), habit: Habit(name: "Eating hamburger", description: "Hamburger is health to body.", completeTimes: 0))
    }
}
