//
//  ContentView.swift
//  Dice
//
//  Created by Ma Xueyuan on 2020/01/05.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSetting = false
    @State private var setting = Setting()
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: DiceResult.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \DiceResult.throwTime, ascending: false)
    ]) var diceResults: FetchedResults<DiceResult>
    
    var body: some View {
        NavigationView {
            TabView {
                ThrowView(setting: setting)
                    .tabItem {
                        Image(systemName: "square")
                        Text("Roll")
                    }
                
                ResultView(diceResults: diceResults)
                    .tabItem {
                        Image(systemName: "clock")
                        Text("History")
                    }
            }
            .navigationBarTitle("Dice")
            .navigationBarItems(trailing: Button(action: {
                self.showingSetting = true
            }, label: {
                Text("Setting")
            }))
            .sheet(isPresented: $showingSetting) {
                SettingView(setting: self.$setting)
            }
            .environment(\.managedObjectContext, moc)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
