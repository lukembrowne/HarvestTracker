//
//  Harvest.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/1/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import CoreData

extension Harvest {
    
    func printHarvest() {
        print(self)
    }
    
    
    // Add Harvest
    static func addHarvest(crop: String,
                       weight: String,
                       harvestDate: Date,
                       unit: String,
                       isPresented: Binding<Bool>,
                       in managedObjectContext: NSManagedObjectContext) {
         // 1
         let newHarvest = Harvest(context: managedObjectContext)

         newHarvest.crop = crop
         newHarvest.weight = Double(weight) ?? 0.0
         newHarvest.harvestDate = harvestDate
         newHarvest.unit = unit

          do {
            try managedObjectContext.save()
          } catch {
            print("Error saving managed object context: \(error)")
          }
       }
    
    // Add Default Harvest
    static func addDefaultHarvests(in managedObjectContext: NSManagedObjectContext) {
        
        let newHarvest = Harvest(context: managedObjectContext)
              
        newHarvest.crop = "default harvest init"
        newHarvest.weight = 420
        
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
