//
//  DiceResult+CoreDataProperties.swift
//  Dice
//
//  Created by Ma Xueyuan on 2020/01/05.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//
//

import Foundation
import CoreData


extension DiceResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiceResult> {
        return NSFetchRequest<DiceResult>(entityName: "DiceResult")
    }

    @NSManaged public var type: String?
    @NSManaged public var point: Int16
    @NSManaged public var throwTime: Date?

    var wrappedType: String {
        return type ?? ""
    }
    
    var wrappedPoint: String {
        return "\(point)"
    }
    
    var wrappedThrowTime: String {
        guard let wrappedDate = throwTime else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: wrappedDate)
    }
}
