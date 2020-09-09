//
//  Harvest+CoreDataClass.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/9/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//
//

import SwiftUI
import CoreData

@objc(Harvest)
public class Harvest: NSManagedObject {
    
    
    
    func printHarvest() {
        print(self)
    }
    
    
    // Add Harvest
    static func addHarvest(crop: Crop?,
                           amountEntered: String,
                           harvestDate: Date,
                           unit: String,
                           isPresented: Binding<Bool>,
                           in managedObjectContext: NSManagedObjectContext) {
        
        let newHarvest = Harvest(context: managedObjectContext)
        
        newHarvest.crop = crop
        newHarvest.amountEntered = Double(amountEntered) ?? 0.0
        newHarvest.harvestDate = harvestDate
        newHarvest.unitEntered = unit
        
        // Standardize amount
        switch unit {
        case "oz":
            //            print("oz selected")
            newHarvest.amountStandardized = Measurement(value: newHarvest.amountEntered,
                                                        unit: UnitMass.ounces).converted(to: UnitMass.grams).value
        case "lb":
            //            print("lb selected")
            newHarvest.amountStandardized = Measurement(value: newHarvest.amountEntered,
                                                        unit: UnitMass.pounds).converted(to: UnitMass.grams).value
        case "g":
            //            print("g selected")
            newHarvest.amountStandardized = Measurement(value: newHarvest.amountEntered,
                                                        unit: UnitMass.grams).converted(to: UnitMass.grams).value
        case "kg":
            //            print("kg selected")
            newHarvest.amountStandardized = Measurement(value: newHarvest.amountEntered,
                                                        unit: UnitMass.kilograms).converted(to: UnitMass.grams).value
        default:
            print("Unrecognized unit")
        }
        
        
        // Save
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
// Delete Harvest
    static func deleteHarvest(harvest: Harvest, in managedObjectContext: NSManagedObjectContext ) {
        
        // Delete
        managedObjectContext.delete(harvest)
        
        // Save
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
    }
    
    
}
