//
//  GeometryScrollView2.swift
//  LayoutAndGeometry
//
//  Created by Ma Xueyuan on 2020/01/04.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct GeometryScrollView2: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<50) { index in
                        GeometryReader { geo in
                            Rectangle()
                                .fill(self.colors[index % 7])
                                .frame(height: 150)
                                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 10), axis: (x: 0, y: 1, z: 0))
                        }
                        .frame(width: 150)
                    }
                }
                .padding(.horizontal, ((fullView.size.width - 150) / 2))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("GeometryScroll2")
    }
}

struct GeometryScrollView2_Previews: PreviewProvider {
    static var previews: some View {
        GeometryScrollView2()
    }
}
