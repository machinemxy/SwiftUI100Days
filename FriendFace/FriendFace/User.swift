//
//  User.swift
//  FriendFace
//
//  Created by Ma Xueyuan on 2019/12/08.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int16
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: String
    var tags: [String]
    var friends: [Friend]
    
    var displayRegistered: String {
        String(registered.replacingOccurrences(of: "T", with: " ").dropLast(6))
    }
    
    var displayTags: String {
        tags.joined(separator: "  ")
    }
    
    var sortedFriends: [Friend] {
        friends.sorted { (f1, f2) -> Bool in
            f1.name < f2.name
        }
    }
}
