//
//  ContentView.swift
//  Animations
//
//  Created by Ma Xueyuan on 2019/11/11.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        Button("Tap Me") {
            // do nothing
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
            .stroke(Color.red)
            .scaleEffect(animationAmount)
            .opacity(Double(2 - animationAmount))
            .animation(
                Animation.easeOut(duration: 1)
                .repeatForever(autoreverses: false)
            )
        )
        .onAppear {
            self.animationAmount = 2
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
