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
        // 1
        let newCrop = Crop(context: managedObjectContext)
        
        newCrop.cropName = cropName
        newCrop.costPerUnit = Double(costPerUnit) ?? 0.0
        newCrop.unit = unit
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    
    // Load default crops if no crops are in database
    static func loadDefaultCrops(in managedObjectContext: NSManagedObjectContext) {
        
        for crop in cropsJSONDecoded {
            let newCrop = Crop(context: managedObjectContext)
            
            newCrop.cropName = crop.cropName
            newCrop.costPerUnit = crop.costPerUnit
            newCrop.unit = crop.unit
        }
        
        // Save
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
    }
    
    
    
    
    
    
    
    
}
