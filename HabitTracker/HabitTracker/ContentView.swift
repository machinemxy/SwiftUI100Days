//
//  ContentView.swift
//  HabitTracker
//
//  Created by Ma Xueyuan on 2019/11/26.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits = Habits()
    @State private var showAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { item in
                    NavigationLink(destination: DetailView(habits: self.habits, habit: item)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name).font(.headline)
                                Text(item.description).font(.subheadline)
                            }
                            Spacer()
                            Text("Times: \(item.completeTimes)")
                        }
                    }
                }.onDelete(perform: removeItems)
            }
            .navigationBarTitle("Habit Tracker")
            .navigationBarItems(leading: EditButton(), trailing: Button("Add") {
                self.showAddView = true
            })
            .sheet(isPresented: $showAddView) {
                AddView(habits: self.habits)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        habits.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
