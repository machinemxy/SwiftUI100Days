//
//  ContentView.swift
//  Triangle
//
//  Created by Ma Xueyuan on 2019/11/24.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct Triangle: InsettableShape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY + insetAmount))
        path.addLine(to: CGPoint(x: rect.minX + insetAmount, y: rect.maxY - insetAmount))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.maxY - insetAmount))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + insetAmount))

        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var triangle = self
        triangle.insetAmount += amount
        return triangle
    }
}

struct ContentView: View {
    var body: some View {
        Triangle()
            .strokeBorder(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
            .border(ImagePaint(image: Image("heart"), scale: 0.2), width: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
