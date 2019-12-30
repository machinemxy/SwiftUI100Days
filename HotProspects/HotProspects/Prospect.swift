//
//  Prospect.swift
//  HotProspects
//
//  Created by Ma Xueyuan on 2019/12/30.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var addedTime = Date()
}

class Prospects: ObservableObject {
    enum SortBy {
        case alphabet, mostRecent
    }
    
    static let saveKey = "SavedData"
    
    @Published private(set) var people: [Prospect]
    @Published var sortBy = SortBy.alphabet
    
    var sortedPeople: [Prospect] {
        if sortBy == .alphabet {
            return people.sorted {
                $0.name < $1.name
            }
        } else {
            return people.sorted {
                $0.addedTime > $1.addedTime
            }
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func delete(atOffsets indexSet : IndexSet) {
        people.remove(atOffsets: indexSet)
        save()
    }
    
    init() {
        if let people: [Prospect] = FileManager.default.loadJson(from: Self.saveKey) {
            self.people = people
        } else {
            self.people = []
        }
    }
    
    private func save() {
        FileManager.default.saveJson(people, to: Self.saveKey)
    }
}
