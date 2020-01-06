//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Ma Xueyuan on 2020/01/06.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var favorites: Favorites
    @State private var selectedFacility: String?
    let resort: Resort
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    
                    VStack() {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Text("Photo by \(self.resort.imageCredit)").layoutPriority(1)
                                .font(.footnote)
                                .foregroundColor(.red)
                            .padding()
                        }
                    }
                }

                HStack {
                    if sizeClass == .compact {
                        Spacer()
                        VStack { ResortDetailsView(resort: resort) }
                        VStack { SkiDetailsView(resort: resort) }
                        Spacer()
                    } else {
                        ResortDetailsView(resort: resort)
                        Spacer().frame(height: 0)
                        SkiDetailsView(resort: resort)
                    }
                }
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    HStack {
                        ForEach(resort.facilities) { facility in
                            Facility.icon(for: facility)
                                .font(.title)
                                .onTapGesture {
                                    self.selectedFacility = facility
                                }
                        }
                    }
                    .padding(.vertical)
                    
                    Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                        if self.favorites.contains(self.resort) {
                            self.favorites.remove(self.resort)
                        } else {
                            self.favorites.add(self.resort)
                        }
                        
                        self.favorites.save()
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitle(Text("\(resort.name), \(resort.country)"), displayMode: .inline)
        .alert(item: $selectedFacility) { facility in
            Facility.alert(for: facility)
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}
