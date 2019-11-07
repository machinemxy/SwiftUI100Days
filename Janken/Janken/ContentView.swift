//
//  ContentView.swift
//  Janken
//
//  Created by Ma Xueyuan on 2019/11/07.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let moves = ["Rock", "Paper", "Scissors"]
    
    @State private var cpuMove = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var showAlert = false
    @State private var score = 0
    @State private var round = 1
    @State private var isCorrectThisRound = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Round \(round)")
            Text("CPU's move is \(moves[cpuMove])")
            Text("If you want to \(shouldWin ? "win" : "lose"), you will go...")
            ForEach(0 ..< moves.count) { number in
                Button(self.moves[number]) {
                    self.judgeResult(number)
                }
            }
            Text("Score: \(score)")
        }
        .alert(isPresented: $showAlert) {
            if round == 10 {
                return Alert(title: Text("\(isCorrectThisRound ? "Correct" : "Wrong")"), message: Text("Final score: \(score)"), dismissButton: .default(Text("Start new game")) {
                    self.newGame()
                })
            } else {
                return Alert(title: Text("\(isCorrectThisRound ? "Correct" : "Wrong")"), message: Text("Current score: \(score)"), dismissButton: .default(Text("Next")) {
                    self.newQuestion()
                })
            }
        }
    }
    
    func judgeResult(_ id: Int) {
        isCorrectThisRound = shouldWin == compare(player: id, cpu: cpuMove)
        if isCorrectThisRound {
            score += 1
        }
        showAlert = true
    }
    
    func compare(player: Int, cpu: Int) -> Bool {
        switch player {
        case 0:
            return cpu == 2
        case 1:
            return cpu == 0
        default:
            return cpu == 1
        }
    }
    
    func newQuestion() {
        round += 1
        cpuMove = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
    
    func newGame() {
        round = 1
        score = 0
        cpuMove = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
