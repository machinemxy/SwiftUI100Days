//
//  ContentView.swift
//  LengthConversion
//
//  Created by Ma Xueyuan on 2019/11/05.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnitId = 0
    @State private var outputUnitId = 0
    @State private var inputValue = ""
    
    var outputValue: Double {
        let inputDouble = Double(inputValue) ?? 0.0
        let input = Measurement(value: inputDouble, unit: unitLengths[inputUnitId])
        let output = input.converted(to: unitLengths[outputUnitId])
        return output.value
    }
    
    let units = ["meters", "kilometers", "feet", "yards", "miles"]
    let unitLengths = [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input unit")) {
                    Picker("", selection: $inputUnitId) {
                        ForEach(0 ..< units.count) {
                            Text("\(self.units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output unit")) {
                    Picker("", selection: $outputUnitId) {
                        ForEach(0 ..< units.count) {
                            Text("\(self.units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Input value")) {
                    TextField("Input value", text: $inputValue).keyboardType(.decimalPad)
                }
                
                Section(header: Text("Output value")) {
                    Text("\(outputValue, specifier: "%.5f")")
                }
            }
            .navigationBarTitle("Length Conversion")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
