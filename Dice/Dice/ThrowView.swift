//
//  ThrowView.swift
//  Dice
//
//  Created by Ma Xueyuan on 2020/01/05.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ThrowView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var total = 0
    @State private var diceImageNames = Array.init(repeating: "square", count: 3)
    @State private var diceSizes = Array.init(repeating: CGFloat(200), count: 3)
    @State private var diceOffsetXs = Array.init(repeating: CGFloat(0), count: 3)
    @State private var diceOffsetYs = Array.init(repeating: CGFloat(0), count: 3)
    @State private var diceDegrees = Array.init(repeating: Double(0), count: 3)
    @State private var diceRolled = false
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var setting: Setting
    
    
    var body: some View {
        VStack {
            Text("Total: \(total)")
                .font(.largeTitle)
            
            Button(action: {
                if self.diceRolled {
                    self.reset()
                } else {
                    self.roll()
                }
            }) {
                diceRolled ? Text("Reset") : Text("Roll")
            }.font(.largeTitle)
            
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<self.setting.dices) { i in
                        Image(systemName: self.diceImageNames[i])
                            .resizable()
                            .frame(width: self.diceSizes[i], height: self.diceSizes[i])
                            .offset(x: geo.size.width * self.diceOffsetXs[i], y: geo.size.height * self.diceOffsetYs[i])
                            .rotationEffect(.degrees(self.diceDegrees[i]))
                    }
                }
            }
        }
    }
    
    func roll() {
        var sum = 0
        
        withAnimation {
            for i in 0..<self.setting.dices {
                let point = Int.random(in: 1...self.setting.sides)
                sum += point
                diceImageNames[i] = "\(point).square"
                diceSizes[i] = 50
                diceOffsetXs[i] = CGFloat.random(in: -0.3...0.3)
                diceOffsetYs[i] = CGFloat.random(in: -0.3...0.3)
                diceDegrees[i] = Double.random(in: 0..<360)
            }
        }
        
        total = sum
        self.feedback.notificationOccurred(.error)
        
        // save result
        let diceResult = DiceResult(context: moc)
        diceResult.type = "\(setting.dices)D\(setting.sides)"
        diceResult.point = Int16(total)
        diceResult.throwTime = Date()
        try? moc.save()
        
        diceRolled = true
    }
    
    func reset() {
        withAnimation {
            for i in 0..<self.setting.dices {
                diceImageNames[i] = "square"
                diceSizes[i] = 200
                diceOffsetXs[i] = 0
                diceOffsetYs[i] = 0
                diceDegrees[i] = 0
            }
        }
        
        total = 0
        diceRolled = false
    }
}

struct ThrowView_Previews: PreviewProvider {
    static var previews: some View {
        ThrowView(setting: Setting())
    }
}
