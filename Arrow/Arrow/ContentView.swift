//
//  ContentView.swift
//  Arrow
//
//  Created by Ma Xueyuan on 2019/11/25.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct Arrow: Shape {
    var width: CGFloat
    
    public var animatableData: CGFloat {
        get {
            width
        }
        set {
            width = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX - width * 1.5, y: rect.minY + rect.height / 4))
        path.addLine(to: CGPoint(x: rect.midX - width * 0.5, y: rect.minY + rect.height / 4))
        path.addLine(to: CGPoint(x: rect.midX - width * 0.5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + width * 0.5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + width * 0.5, y: rect.minY + rect.height / 4))
        path.addLine(to: CGPoint(x: rect.midX + width * 1.5, y: rect.minY + rect.height / 4))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 50

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView: View {
    @State private var width = CGFloat(20)
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                Arrow(width: width)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .frame(width: 200, height: 200)
                ColorCyclingRectangle(amount: colorCycle)
                    .frame(width:350, height: 350)
            }
            .drawingGroup()
            Spacer()
            Text("Width of arrow:")
            Slider(value: $width, in: 20...50).padding([.horizontal, .bottom])
            Text("Hue:")
            Slider(value: $colorCycle).padding([.horizontal, .bottom])
            Button("Change Randomly") {
                withAnimation {
                    self.width = CGFloat.random(in: 20...50)
                    self.colorCycle = Double.random(in: 0..<1)
                }
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
