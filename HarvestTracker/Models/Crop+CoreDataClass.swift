//
//  Crop+CoreDataClass.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/9/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Crop)
public class Crop: NSManagedObject {
    
    
    // Add Crop
    static func addCrop(cropName: String,
                        costPerUnit: String,
                        unit: String,
                        in managedObjectContext: NSManagedObjectContext) {
        let newCrop = Crop(context: managedObjectContext)
        
        newCrop.cropName = cropName
        newCrop.costPerUnit = Double(costPerUnit) ?? 0
        newCrop.unit = unit
        
        // Standardize cost per unit
        switch unit {
        case "oz":
            newCrop.costPerG = newCrop.costPerUnit / 28.3495
        case "lb":
            newCrop.costPerG = newCrop.costPerUnit / 453.592
        case "g":
            newCrop.costPerG = newCrop.costPerUnit
        case "kg":
            newCrop.costPerG = newCrop.costPerUnit / 999.9991843
        default:
            print("Unrecognized unit")
        }
        
        print(newCrop)
        
        
        // Save
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    
    // Load default crops if no crops are in database
    static func loadDefaultCrops(in managedObjectContext: NSManagedObjectContext) {
        
        print("Loading default crops")
        
        for crop in cropsJSONDecoded {
            addCrop(cropName: crop.cropName,
                    costPerUnit: String(crop.costPerUnit),
                    unit: crop.unit,
                    in: managedObjectContext)
        }
        
//        for crop in cropsJSONDecoded {
//            let newCrop = Crop(context: managedObjectContext)
//
//            newCrop.cropName = crop.cropName
//            newCrop.costPerUnit = crop.costPerUnit
//            newCrop.unit = crop.unit
//        }
//
//        // Save
//        do {
//            try managedObjectContext.save()
//        } catch {
//            print("Error saving managed object context: \(error)")
//        }
        
    }
    
    
    
    
    
    
    
    
}
