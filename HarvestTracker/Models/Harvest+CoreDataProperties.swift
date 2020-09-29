//
//  Harvest+CoreDataProperties.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/9/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//
//

import SwiftUI
import CoreData


extension Harvest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Harvest> {
        return NSFetchRequest<Harvest>(entityName: "Harvest")
    }

    @NSManaged public var amountEntered: Double
    @NSManaged public var amountStandardized: Double
    @NSManaged public var crop: Crop?
    @NSManaged public var harvestDate: Date?
    @NSManaged public var unitEntered: String?
    @NSManaged public var tagArray: [Tag]?

}


// MARK: Generated accessors for tagArray
extension Harvest {

    @objc(insertObject:inTagArrayAtIndex:)
    @NSManaged public func insertIntoTagArray(_ value: Tag, at idx: Int)

    @objc(removeObjectFromTagArrayAtIndex:)
    @NSManaged public func removeFromTagArray(at idx: Int)

    @objc(insertTagArray:atIndexes:)
    @NSManaged public func insertIntoTagArray(_ values: [Tag], at indexes: NSIndexSet)

    @objc(removeTagArrayAtIndexes:)
    @NSManaged public func removeFromTagArray(at indexes: NSIndexSet)

    @objc(replaceObjectInTagArrayAtIndex:withObject:)
    @NSManaged public func replaceTagArray(at idx: Int, with value: Tag)

    @objc(replaceTagArrayAtIndexes:withTagArray:)
    @NSManaged public func replaceTagArray(at indexes: NSIndexSet, with values: [Tag])

    @objc(addTagArrayObject:)
    @NSManaged public func addToTagArray(_ value: Tag)

    @objc(removeTagArrayObject:)
    @NSManaged public func removeFromTagArray(_ value: Tag)

    @objc(addTagArray:)
    @NSManaged public func addToTagArray(_ values: NSOrderedSet)

    @objc(removeTagArray:)
    @NSManaged public func removeFromTagArray(_ values: NSOrderedSet)

}

extension Harvest : Identifiable {

}

