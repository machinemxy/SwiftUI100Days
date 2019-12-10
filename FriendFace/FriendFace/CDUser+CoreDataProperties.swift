//
//  CDUser+CoreDataProperties.swift
//  FriendFace
//
//  Created by Ma Xueyuan on 2019/12/10.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: String?
    @NSManaged public var tags: String?
    @NSManaged public var friends: String?

    var user: User {
        // I user so many force unwrap to show my anger to this project!
        let decodedTags = try! JSONDecoder().decode([String].self, from: tags!.data(using: .utf8)!)
        let decodedFriends = try! JSONDecoder().decode([Friend].self, from: friends!.data(using: .utf8)!)
        return User(
            id: id!,
            isActive: isActive,
            name: name!,
            age: age,
            company: company!,
            email: email!,
            address: address!,
            about: about!,
            registered: registered!,
            tags: decodedTags,
            friends: decodedFriends
        )
    }
    
    func setProperties(from user: User) {
        id = user.id
        isActive = user.isActive
        name = user.name
        age = user.age
        company = user.company
        email = user.email
        address = user.address
        about = user.about
        registered = user.registered
        let tagsData = try! JSONEncoder().encode(user.tags)
        tags = String(data: tagsData, encoding: .utf8)
        let friendsData = try! JSONEncoder().encode(user.friends)
        friends = String(data: friendsData, encoding: .utf8)
    }
}
