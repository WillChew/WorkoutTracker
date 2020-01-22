//
//  Sett+CoreDataProperties.swift
//  WorkoutTracker
//
//  Created by Will Chew on 2020-01-22.
//  Copyright © 2020 Will Chew. All rights reserved.
//
//

import Foundation
import CoreData


extension Sett {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sett> {
        return NSFetchRequest<Sett>(entityName: "Sett")
    }

    @NSManaged public var notes: String?
    @NSManaged public var reps: Int32
    @NSManaged public var uuid: UUID?
    @NSManaged public var weight: Double
    @NSManaged public var exercise: Exercise?

}
