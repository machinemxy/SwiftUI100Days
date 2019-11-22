//
//  ContentView.swift
//  Moonshot
//
//  Created by Ma Xueyuan on 2019/11/18.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut]
    let missions: [Mission]
    let missionsViewModels: [MissionViewModel]
    
    @State private var isShowingDate = true
    
    var body: some View {
        NavigationView {
            List(missionsViewModels) { mvm in
                NavigationLink(destination: MissionView(missions: self.missions, mission: mvm.mission, astronauts: self.astronauts)) {
                    Image(mvm.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mvm.mission.displayName)
                            .font(.headline)
                        Text(self.isShowingDate ? mvm.mission.formattedLaunchDate : mvm.dispCrewNames)
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing: Button("Switch") {
                self.isShowingDate.toggle()
            })
        }
    }
    
    init() {
        astronauts = Bundle.main.decode("astronauts.json")
        missions = Bundle.main.decode("missions.json")
        var tempMVM = [MissionViewModel]()
        for mission in missions {
            tempMVM.append(MissionViewModel(mission: mission, astronauts: astronauts))
        }
        missionsViewModels = tempMVM
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
