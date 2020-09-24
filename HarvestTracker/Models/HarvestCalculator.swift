//
//  HarvestCalculator.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/24/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct HarvestCalculator {
    
    var harvests: FetchedResults<Harvest>

    // Calculate total Harvest
     func calcTotalHarvest() -> Double {
        
        var totalHarvestAmount = 0.0
        var totalHarvestValue = 0.0

        // Loop over harvests if there are harvests
        if(harvests.count > 0){
            for index in 0...harvests.count - 1 {
                
                
                //                print(index)
                totalHarvestAmount += harvests[index].amountStandardized
                totalHarvestValue += harvests[index].amountStandardized * harvests[index].crop!.costPerG
            }
        } else {
            totalHarvestAmount = 0.0
        }
        
        // Convert to displayed unit
        totalHarvestAmount = Measurement(value: totalHarvestAmount, unit: UnitMass.grams).converted(to: .kilograms).value
        
        return totalHarvestAmount
        
    }
    
}

