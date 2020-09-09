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

}
