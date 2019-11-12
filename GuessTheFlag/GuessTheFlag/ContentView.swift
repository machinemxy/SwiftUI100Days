//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ma Xueyuan on 2019/11/05.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct Flag: View {
    let flagName: String
    
    var body: some View {
        Image(flagName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    // animation related
    @State private var spinDegree = 0.0
    @State private var opacity = 1.0
    @State private var blur: CGFloat = 0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                Text(countries[correctAnswer]).foregroundColor(.white).font(.largeTitle).fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    if self.correctAnswer == number {
                        Button(action: {
                            self.flagTapped(number)
                        }) {
                            Flag(flagName: self.countries[number])
                        }
                        .rotation3DEffect(.degrees(self.spinDegree), axis: (x: 0, y: 1, z: 0))
                        .blur(radius: self.blur)
                    } else {
                        Button(action: {
                            self.flagTapped(number)
                        }) {
                            Flag(flagName: self.countries[number])
                        }
                        .opacity(self.opacity)
                        .blur(radius: self.blur)
                    }
                }
                
                Text("Current score: \(score)").foregroundColor(.white)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                }
            )
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            withAnimation {
                spinDegree += 360
                opacity = 0.25
            }
        } else {
            score -= 1
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            withAnimation {
                blur = 10
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        spinDegree = 0
        opacity = 1.0
        blur = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
