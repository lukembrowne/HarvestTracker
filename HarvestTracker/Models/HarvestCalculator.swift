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
    var monthlyTotals = [Double](repeating: 0, count: 12)
    @ObservedObject var defaultUnit = DefaultUnit()

    // Calculate total Harvest
     func calcTotalHarvest() -> Double {
        
        var totalHarvestAmount = 0.0
        var totalHarvestValue = 0.0
                

        // Loop over harvests if there are harvests
        if(harvests.count > 0){
            for index in 0...harvests.count - 1 {
                
                totalHarvestAmount += harvests[index].amountStandardized
                totalHarvestValue += harvests[index].amountStandardized * harvests[index].crop!.costPerG
            }
        } else {
            totalHarvestAmount = 0.0
        }
        
        // Convert to displayed unit
        totalHarvestAmount = Measurement(value: totalHarvestAmount, unit: UnitMass.grams).converted(to: defaultUnit.unitMass).value
        
        return totalHarvestAmount
        
    }
    
    
    // Returns array of monthly harvest totals by month
    
    // TODO: - make it work by year as well
    func calcTotalByMonth() -> ChartData {
        
        var monthlyTotals = [Double](repeating: 0, count: 12)
        
        // Loop over harvests if there are harvests
        if(harvests.count > 0){
            for index in 0...harvests.count - 1 {
                
                // Extract year and month from harvest date, if harvest date exists
                if let date = harvests[index].harvestDate {
                    
                   let yearMonth = Calendar.current.dateComponents([.year, .month], from: date)
                    
                    if let month = yearMonth.month {
                        
                        monthlyTotals[month - 1] += harvests[index].amountStandardized

                    }
                }
            }
        } // End harvest loop
        
        
        var chartData = ChartData(values: [("J", monthlyTotals[0]),
                                       ("F", monthlyTotals[1]),
                                       ("M", monthlyTotals[2]),
                                       ("A", monthlyTotals[3]),
                                       ("M", monthlyTotals[4]),
                                       ("J", monthlyTotals[5]),
                                       ("J", monthlyTotals[6]),
                                       ("A", monthlyTotals[7]),
                                       ("S", monthlyTotals[8]),
                                       ("O", monthlyTotals[9]),
                                       ("N", monthlyTotals[10]),
                                       ("D", monthlyTotals[11])])
        
        return chartData
        
    }
    
    
}

