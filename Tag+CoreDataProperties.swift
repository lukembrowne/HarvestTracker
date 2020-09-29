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

    @NSManaged public var tagName: String?
    @NSManaged public var tagColor: String?
    @NSManaged public var harvest: Set<Tag>?

}

// MARK: Generated accessors for harvest
extension Tag {

    @objc(addHarvestObject:)
    @NSManaged public func addToHarvest(_ value: Harvest)

    @objc(removeHarvestObject:)
    @NSManaged public func removeFromHarvest(_ value: Harvest)

    @objc(addHarvest:)
    @NSManaged public func addToHarvest(_ values: NSSet)

    @objc(removeHarvest:)
    @NSManaged public func removeFromHarvest(_ values: NSSet)

}

extension Tag : Identifiable {

}
