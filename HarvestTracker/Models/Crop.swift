//
//  Crop.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/1/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import CoreData

extension Crop {
    
    
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



// Need to set Crop struct in JSON format to be able to decode it
struct CropJSON: Decodable {
    
    let cropName: String
    let costPerUnit: Double
    let unit: String
    
}

// Raw crop data to initialize database
let cropJSONRaw = """
    [
      {
        "cropName": "basil",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "beets",
        "costPerUnit": 0.124,
        "unit": "ounce"
      },
      {
        "cropName": "carrot - whole",
        "costPerUnit": 0.13,
        "unit": "ounce"
      },
      {
        "cropName": "chamomille - dried",
        "costPerUnit": 1.64,
        "unit": "ounce"
      },
      {
        "cropName": "cilantro",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "corn",
        "costPerUnit": 0.99,
        "unit": "cob"
      },
      {
        "cropName": "cucumbers",
        "costPerUnit": 0.249,
        "unit": "ounce"
      },
      {
        "cropName": "eggplant - japanese",
        "costPerUnit": 0.23,
        "unit": "ounce"
      },
      {
        "cropName": "eggplant - normal",
        "costPerUnit": 0.23,
        "unit": "ounce"
      },
      {
        "cropName": "green beans",
        "costPerUnit": 0.25,
        "unit": "ounce"
      },
      {
        "cropName": "kale and chard",
        "costPerUnit": 2.99,
        "unit": "bunch"
      },
      {
        "cropName": "mixed greens",
        "costPerUnit": 0.749,
        "unit": "ounce"
      },
      {
        "cropName": "oregano",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "parsley",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "peppers - banana",
        "costPerUnit": 0.156,
        "unit": "ounce"
      },
      {
        "cropName": "peppers - bell",
        "costPerUnit": 2.5,
        "unit": "per pepper"
      },
      {
        "cropName": "peppers - sweet mini",
        "costPerUnit": 0.156,
        "unit": "ounce"
      },
      {
        "cropName": "sage",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "shelled peas",
        "costPerUnit": 0.1,
        "unit": "ounce"
      },
      {
        "cropName": "strawberries",
        "costPerUnit": 0.249,
        "unit": "ounce"
      },
      {
        "cropName": "sugar snap peas",
        "costPerUnit": 0.39,
        "unit": "ounce"
      },
      {
        "cropName": "thyme",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "tomatillos",
        "costPerUnit": 0.249,
        "unit": "ounce"
      },
      {
        "cropName": "tomatos",
        "costPerUnit": 0.3118,
        "unit": "ounce"
      },
      {
        "cropName": "zucchini",
        "costPerUnit": 0.186,
        "unit": "ounce"
      },
      {
        "cropName": "zucchini_flowers",
        "costPerUnit": 0.58,
        "unit": "one flower"
      }
    ]
"""


// code for parsing and loading JSON from: avanderlee.com/swift/json-parsing-decoding/
let cropsJSONDecoded: [CropJSON] = try! JSONDecoder().decode([CropJSON].self, from: cropJSONRaw.data(using: .utf8)!)
