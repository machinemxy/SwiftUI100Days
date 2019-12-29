//
//  ContentView.swift
//  HotProspects
//
//  Created by Ma Xueyuan on 2019/12/28.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .tabItem {
                    Image(systemName: "star")
                    Text("One")
                }
                .onTapGesture {
                    self.selectedTab = 1
                }
                .tag(0)
            
            Text("Tab 2")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Two")
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
