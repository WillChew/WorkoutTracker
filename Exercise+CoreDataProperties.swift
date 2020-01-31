//
//  Exercise+CoreDataProperties.swift
//  WorkoutTracker
//
//  Created by Will Chew on 2020-01-31.
//  Copyright © 2020 Will Chew. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var type: String?
    @NSManaged public var set: NSOrderedSet?
    @NSManaged public var workout: Workout?

}

// MARK: Generated accessors for set
extension Exercise {

    @objc(insertObject:inSetAtIndex:)
    @NSManaged public func insertIntoSet(_ value: Sett, at idx: Int)

    @objc(removeObjectFromSetAtIndex:)
    @NSManaged public func removeFromSet(at idx: Int)

    @objc(insertSet:atIndexes:)
    @NSManaged public func insertIntoSet(_ values: [Sett], at indexes: NSIndexSet)

    @objc(removeSetAtIndexes:)
    @NSManaged public func removeFromSet(at indexes: NSIndexSet)

    @objc(replaceObjectInSetAtIndex:withObject:)
    @NSManaged public func replaceSet(at idx: Int, with value: Sett)

    @objc(replaceSetAtIndexes:withSet:)
    @NSManaged public func replaceSet(at indexes: NSIndexSet, with values: [Sett])

    @objc(addSetObject:)
    @NSManaged public func addToSet(_ value: Sett)

    @objc(removeSetObject:)
    @NSManaged public func removeFromSet(_ value: Sett)

    @objc(addSet:)
    @NSManaged public func addToSet(_ values: NSOrderedSet)

    @objc(removeSet:)
    @NSManaged public func removeFromSet(_ values: NSOrderedSet)

}
