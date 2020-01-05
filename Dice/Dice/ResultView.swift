//
//  ResultView.swift
//  Dice
//
//  Created by Ma Xueyuan on 2020/01/05.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.managedObjectContext) var moc
    
    var diceResults: FetchedResults<DiceResult>
    
    var body: some View {
        List {
            ForEach(diceResults, id: \.objectID) { diceResult in
                VStack(alignment: .leading) {
                    Text("\(diceResult.wrappedType): \(diceResult.wrappedPoint)")
                        .font(.headline)
                    Text("\(diceResult.wrappedThrowTime)")
                        .font(.subheadline)
                }
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(indexSet: IndexSet) {
        for i in indexSet {
            moc.delete(diceResults[i])
        }
        try? moc.save()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        Text("aa")
    }
}
