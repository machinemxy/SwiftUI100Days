//
//  AddView.swift
//  HabitTracker
//
//  Created by Ma Xueyuan on 2019/11/26.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habits: Habits
    @State private var name = ""
    @State private var description = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Habit name", text: $name)
                TextField("Description", text: $description)
            }
            .navigationBarTitle("Add new habit", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save", action: save))
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Please enter the name of the habit."), dismissButton: .default(Text("OK")))
        }
    }
    
    func save() {
        if name == "" {
            self.showAlert = true
            return
        }
        
        habits.items.append(Habit(name: name, description: description, completeTimes: 0))
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(habits: Habits())
    }
}
