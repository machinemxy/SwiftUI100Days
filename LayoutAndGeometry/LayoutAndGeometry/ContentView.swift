//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Ma Xueyuan on 2020/01/02.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HStack(alignment: .midAccountAndName) {
                VStack {
                    Text("@twostraws")
                        .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                    Image("example")
                        .resizable()
                        .frame(width: 64, height: 64)
                }

                VStack {
                    Text("Full name:")
                    Text("PAUL HUDSON")
                        .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                        .font(.largeTitle)
                }
            }
            .navigationBarTitle("Custom Alignment", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: GeometryReaderView(), label: {
                Text("Next")
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension VerticalAlignment {
    struct MidAccountAndName: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.top]
        }
    }

    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}
