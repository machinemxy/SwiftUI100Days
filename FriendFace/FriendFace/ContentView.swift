//
//  ContentView.swift
//  FriendFace
//
//  Created by Ma Xueyuan on 2019/12/08.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var users = Users()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users.userList) { user in
                    Text(user.name)
                }
            }
            .onAppear(perform: loadData)
            .navigationBarTitle("FriendFace")
        }
    }
    
    func loadData() {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            fatalError("Failed to access to URL.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data.")
        }
        
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode([User].self, from: data) else {
            fatalError("Failed to decode data.")
        }
        
        users.userList = loaded
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
