//
//  Candy+CoreDataProperties.swift
//  CoreDataOneToMany
//
//  Created by Ma Xueyuan on 2019/12/10.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//
//

import Foundation
import CoreData


extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?

    public var wrappedName: String {
        name ?? "Unknown Candy"
    }
}
