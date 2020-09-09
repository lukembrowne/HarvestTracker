//
//  Crop+CoreDataProperties.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/9/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//
//

import Foundation
import CoreData


extension Crop: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Crop> {
        return NSFetchRequest<Crop>(entityName: "Crop")
    }

    @NSManaged public var costPerUnit: Double
    @NSManaged public var cropName: String?
    @NSManaged public var unit: String?
    @NSManaged public var harvests: NSSet?
    
    

}

// MARK: Generated accessors for harvests
extension Crop {

    @objc(addHarvestsObject:)
    @NSManaged public func addToHarvests(_ value: Harvest)

    @objc(removeHarvestsObject:)
    @NSManaged public func removeFromHarvests(_ value: Harvest)

    @objc(addHarvests:)
    @NSManaged public func addToHarvests(_ values: NSSet)

    @objc(removeHarvests:)
    @NSManaged public func removeFromHarvests(_ values: NSSet)

}
