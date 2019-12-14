//
//  ContentView.swift
//  BucketList
//
//  Created by Ma Xueyuan on 2019/12/14.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct Cat: Codable {
    var color: String
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
        .onAppear(perform: saveCat)
        .onTapGesture(perform: loadCat)
    }
    
    func saveCat() {
        let cat = Cat(color: "white")
        FileManager.default.save(cat, to: "cat.json")
    }
    
    func loadCat() {
        let cat: Cat = FileManager.default.load(from: "cat.json")
        print(cat.color)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
