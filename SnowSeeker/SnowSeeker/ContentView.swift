//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Ma Xueyuan on 2020/01/06.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    enum SortBy {
        case def, alphabetical, country
    }
    
    @ObservedObject var favorites = Favorites()
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var sortedAndFilteredResorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var showingSortCondition = false
    @State private var showingFilterView = false
    @State private var sortBy = SortBy.def
    @State private var filter = Filter()
    
    var body: some View {
        NavigationView {
            List(sortedAndFilteredResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
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

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(Color.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .environmentObject(favorites)
            .navigationBarItems(leading: Button(action: {
                self.showingSortCondition = true
            }, label: {
                Text("Sort")
            })
            , trailing: Button(action: {
                self.showingFilterView = true
            }
            , label: {
                Text("Filter")
            }))
            .sheet(isPresented: $showingFilterView, onDismiss: updateSortedAndFilteredResorts) {
                FilterView(filter: self.$filter)
            }
            .actionSheet(isPresented: $showingSortCondition) {
                ActionSheet(title: Text("Sort by"), message: nil, buttons: [
                    .default(Text("Default"), action: {
                        self.sortBy = .def
                        self.updateSortedAndFilteredResorts()
                    }),
                    .default(Text("Alphabetical"), action: {
                        self.sortBy = .alphabetical
                        self.updateSortedAndFilteredResorts()
                    }),
                    .default(Text("Country"), action: {
                        self.sortBy = .country
                        self.updateSortedAndFilteredResorts()
                    }),
                    .cancel()
                ])
            }
            
            WelcomeView()
        }
        
    }
    
    func updateSortedAndFilteredResorts() {
        var tempResorts: [Resort]
        
        // sort
        switch sortBy {
        case .def:
            tempResorts = resorts
        case .alphabetical:
            tempResorts = resorts.sorted(by: { (r1, r2) -> Bool in
                r1.name < r2.name
            })
        case .country:
            tempResorts = resorts.sorted(by: { (r1, r2) -> Bool in
                r1.country < r2.country
            })
        }
        
        // filter
        sortedAndFilteredResorts = tempResorts.filter({ (resort) -> Bool in
            filter.countries.contains(resort.country) &&
                filter.prices.contains(resort.price) &&
                filter.sizes.contains(resort.size)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
