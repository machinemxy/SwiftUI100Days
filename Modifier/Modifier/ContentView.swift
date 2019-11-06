//
//  ContentView.swift
//  Modifier
//
//  Created by Ma Xueyuan on 2019/11/06.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct Title : ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle).foregroundColor(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!").titleStyle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
