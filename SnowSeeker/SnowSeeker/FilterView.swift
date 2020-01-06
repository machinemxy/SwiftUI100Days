//
//  FilterView.swift
//  SnowSeeker
//
//  Created by Ma Xueyuan on 2020/01/07.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var filter: Filter
    let countries = ["Austria", "Canada", "France", "Italy", "United States"]
    let sizeDescription = ["Small", "Average", "Large"]
    @State private var selectedCountries = [String]()
    @State private var selectedSizes = [Int]()
    @State private var selectedPrices = [Int]()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Country")) {
                    List(countries) { country in
                        Button(action: {
                            if self.selectedCountries.contains(country) {
                                if let index = self.selectedCountries.firstIndex(of: country) {
                                    self.selectedCountries.remove(at: index)
                                }
                            } else {
                                self.selectedCountries.append(country)
                            }
                        }) {
                            if self.selectedCountries.contains(country) {
                                Image(systemName: "checkmark.square")
                            } else {
                                Image(systemName: "square")
                            }
                        }
                        
                        Image(country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    }
                }
                
                Section(header: Text("Size")) {
                    List(1...3, id: \.self) { size in
                        Button(action: {
                            if self.selectedSizes.contains(size) {
                                if let index = self.selectedSizes.firstIndex(of: size) {
                                    self.selectedSizes.remove(at: index)
                                }
                            } else {
                                self.selectedSizes.append(size)
                            }
                        }) {
                            if self.selectedSizes.contains(size) {
                                Image(systemName: "checkmark.square")
                            } else {
                                Image(systemName: "square")
                            }
                        }
                        
                        Text(self.sizeDescription[size - 1])
                    }
                }
                
                Section(header: Text("Price")) {
                    List(1...3, id: \.self) { price in
                        Button(action: {
                            if self.selectedPrices.contains(price) {
                                if let index = self.selectedPrices.firstIndex(of: price) {
                                    self.selectedPrices.remove(at: index)
                                }
                            } else {
                                self.selectedPrices.append(price)
                            }
                        }) {
                            if self.selectedPrices.contains(price) {
                                Image(systemName: "checkmark.square")
                            } else {
                                Image(systemName: "square")
                            }
                        }
                        
                        Text(String(repeating: "$", count: price))
                    }
                }
            }
            .navigationBarTitle("Filter", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.filter.countries = self.selectedCountries
                self.filter.sizes = self.selectedSizes
                self.filter.prices = self.selectedPrices
                
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
            }))
            .onAppear {
                self.selectedCountries = self.filter.countries
                self.selectedSizes = self.filter.sizes
                self.selectedPrices = self.filter.prices
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filter: .constant(Filter()))
    }
}
