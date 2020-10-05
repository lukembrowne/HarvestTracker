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
                           chosenTags: [Tag],
                           isPresented: Binding<Bool>,
                           in managedObjectContext: NSManagedObjectContext) {
        
        let newHarvest = Harvest(context: managedObjectContext)
        
        newHarvest.crop = crop
        newHarvest.amountEntered = Double(amountEntered) ?? 0.0
        newHarvest.harvestDate = harvestDate
        newHarvest.unitEntered = unit
        
        // Loop over tags in set and
        chosenTags.forEach {tag in
            print("Adding tag \(tag)")
            tag.addToHarvestArray(newHarvest)
            
        }
        
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
    
    
    // Update Harvest
    static func updateHarvest(harvest: Harvest,
                              crop: Crop?,
                              amountEntered: String,
                              harvestDate: Date,
                              unit: String,
                              chosenTags: [Tag],
                              isPresented: Binding<Bool>,
                              in managedObjectContext: NSManagedObjectContext) {
        
        
        harvest.crop = crop
        harvest.amountEntered = Double(amountEntered) ?? 0.0
        harvest.harvestDate = harvestDate
        harvest.unitEntered = unit
        
        // Remove all old tags
        harvest.tagArray?.forEach { tag in
            tag.removeFromHarvestArray(harvest)
        }
        
        //         Loop over new tags in set and add to harvest
        chosenTags.forEach {tag in
            tag.addToHarvestArray(harvest)
        }
        
        // Standardize amount
        switch unit {
        case "oz":
            //            print("oz selected")
            harvest.amountStandardized = Measurement(value: harvest.amountEntered,
                                                     unit: UnitMass.ounces).converted(to: UnitMass.grams).value
        case "lb":
            //            print("lb selected")
            harvest.amountStandardized = Measurement(value: harvest.amountEntered,
                                                     unit: UnitMass.pounds).converted(to: UnitMass.grams).value
        case "g":
            //            print("g selected")
            harvest.amountStandardized = Measurement(value: harvest.amountEntered,
                                                     unit: UnitMass.grams).converted(to: UnitMass.grams).value
        case "kg":
            //            print("kg selected")
            harvest.amountStandardized = Measurement(value: harvest.amountEntered,
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
