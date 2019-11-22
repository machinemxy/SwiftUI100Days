//
//  MissionViewModel.swift
//  Moonshot
//
//  Created by Ma Xueyuan on 2019/11/22.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

struct MissionViewModel: Identifiable {
    var mission: Mission
    var crewNames: [String]
    var dispCrewNames: String {
        crewNames.joined(separator: ", ")
    }
    var id: Int {
        mission.id
    }
    
    init (mission: Mission, astronauts: [Astronaut]) {
        var matches = [String]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name}) {
                matches.append(match.name)
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.crewNames = matches
        self.mission = mission
    }
}
