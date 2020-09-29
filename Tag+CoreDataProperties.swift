//
//  Tag+CoreDataProperties.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var tagColor: String?
    @NSManaged public var tagName: String?
    @NSManaged public var harvestArray: [Harvest]?

}

// MARK: Generated accessors for harvestArray
extension Tag {

    @objc(insertObject:inHarvestArrayAtIndex:)
    @NSManaged public func insertIntoHarvestArray(_ value: Harvest, at idx: Int)

    @objc(removeObjectFromHarvestArrayAtIndex:)
    @NSManaged public func removeFromHarvestArray(at idx: Int)

    @objc(insertHarvestArray:atIndexes:)
    @NSManaged public func insertIntoHarvestArray(_ values: [Harvest], at indexes: NSIndexSet)

    @objc(removeHarvestArrayAtIndexes:)
    @NSManaged public func removeFromHarvestArray(at indexes: NSIndexSet)

    @objc(replaceObjectInHarvestArrayAtIndex:withObject:)
    @NSManaged public func replaceHarvestArray(at idx: Int, with value: Harvest)

    @objc(replaceHarvestArrayAtIndexes:withHarvestArray:)
    @NSManaged public func replaceHarvestArray(at indexes: NSIndexSet, with values: [Harvest])

    @objc(addHarvestArrayObject:)
    @NSManaged public func addToHarvestArray(_ value: Harvest)

    @objc(removeHarvestArrayObject:)
    @NSManaged public func removeFromHarvestArray(_ value: Harvest)

    @objc(addHarvestArray:)
    @NSManaged public func addToHarvestArray(_ values: NSOrderedSet)

    @objc(removeHarvestArray:)
    @NSManaged public func removeFromHarvestArray(_ values: NSOrderedSet)

}

extension Tag : Identifiable {

}
