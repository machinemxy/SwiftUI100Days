//
//  SettingView.swift
//  Dice
//
//  Created by Ma Xueyuan on 2020/01/05.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var setting: Setting
    @State private var sides = 0
    @State private var dices = 1
    var sidesOptions = [4, 6, 8, 10, 12, 20, 50]
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Sides")) {
                    Picker("", selection: $sides) {
                        ForEach(0 ..< sidesOptions.count) {
                            Text("\(self.sidesOptions[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Dices")) {
                    Stepper(value: $dices, in: 1...3) {
                        Text("\(self.dices)")
                    }
                }
            }
            .navigationBarTitle("Setting", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.setting.sides = self.sidesOptions[self.sides]
                self.setting.dices = self.dices
                
                // save change
                self.setting.save()
                
                // return
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
            }))
        }
        .onAppear {
            self.sides = self.sidesOptions.firstIndex(of: self.setting.sides) ?? 0
            self.dices = self.setting.dices
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(setting: .constant(Setting()))
    }
}
