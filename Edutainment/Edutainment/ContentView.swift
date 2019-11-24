//
//  ContentView.swift
//  Edutainment
//
//  Created by Ma Xueyuan on 2019/11/15.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var isSetting = true
    @State private var maxNumber = 9
    @State private var questionAmountId = 0
    @State private var testStart = false
    
    var questionAmountList = [5, 10, 20, 144]
    var describeList = ["5", "10", "20", "All"]
    
    var body: some View {
        Form {
            Section(header: Text("Max number")) {
                Stepper(value: $maxNumber, in: 1...12) {
                    Text("\(maxNumber)")
                }
            }
            
            Section(header: Text("Question Amount")) {
                Picker("", selection: $questionAmountId) {
                    ForEach(0 ..< describeList.count) {
                        Text(self.describeList[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Are you ready?")) {
                Button("Start") {
                    self.testStart.toggle()
                }
            }
        }
        .sheet(isPresented: $testStart) {
            TestView(maxNumber: self.maxNumber, questionAmount: self.questionAmountList[self.questionAmountId])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
