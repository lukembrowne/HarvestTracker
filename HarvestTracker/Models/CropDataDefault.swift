//
//  Crop.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/1/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import CoreData

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
        "cropName": "Basil",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "Beets",
        "costPerUnit": 0.124,
        "unit": "oz"
      },
      {
        "cropName": "Carrots",
        "costPerUnit": 0.13,
        "unit": "oz"
      },
      {
        "cropName": "Chamomile",
        "costPerUnit": 1.64,
        "unit": "oz"
      },
      {
        "cropName": "Cilantro",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "Corn",
        "costPerUnit": 0.99,
        "unit": "cob"
      },
      {
        "cropName": "Cucumbers",
        "costPerUnit": 0.249,
        "unit": "oz"
      },
      {
        "cropName": "Eggplant",
        "costPerUnit": 0.23,
        "unit": "oz"
      },
      {
        "cropName": "Green beans",
        "costPerUnit": 0.25,
        "unit": "oz"
      },
      {
        "cropName": "Kale",
        "costPerUnit": 2.99,
        "unit": "bunch"
      },
      {
        "cropName": "Mixed greens",
        "costPerUnit": 0.749,
        "unit": "oz"
      },
      {
        "cropName": "Oregano",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "Parsley",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "Peppers",
        "costPerUnit": 0.156,
        "unit": "oz"
      },
      {
        "cropName": "Sage",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "Peas, shelled",
        "costPerUnit": 0.1,
        "unit": "oz"
      },
      {
        "cropName": "Strawberries",
        "costPerUnit": 0.249,
        "unit": "oz"
      },
      {
        "cropName": "Sugar snap peas",
        "costPerUnit": 0.39,
        "unit": "oz"
      },
      {
        "cropName": "Thyme",
        "costPerUnit": 1.99,
        "unit": "bunch"
      },
      {
        "cropName": "Tomatillos",
        "costPerUnit": 0.249,
        "unit": "oz"
      },
      {
        "cropName": "Tomatos",
        "costPerUnit": 0.3118,
        "unit": "oz"
      },
      {
        "cropName": "Zucchini",
        "costPerUnit": 0.186,
        "unit": "oz"
      }
    ]
"""


// code for parsing and loading JSON from: avanderlee.com/swift/json-parsing-decoding/
let cropsJSONDecoded: [CropJSON] = try! JSONDecoder().decode([CropJSON].self,
                                                             from: cropJSONRaw.data(using: .utf8)!)
