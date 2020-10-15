//
//  HarvestCalculator.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/24/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import Foundation

struct HarvestCalculator {
    
    @EnvironmentObject var settings: UserSettings
    
    var harvests: FetchedResults<Harvest>
    var monthlyTotals = [Double](repeating: 0, count: 12)
    
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
        totalHarvestAmount = Measurement(value: totalHarvestAmount, unit: UnitMass.grams).converted(to: settings.unitMass).value
        
        return totalHarvestAmount
        
    }
    
    // Returns array of monthly harvest totals by month
    
    // TODO: - make it work by year as well
    func calcTotalByMonth(filterByTags tags: [Tag]) -> ChartData {
        
        // Initialize empty array of monthly totals
        var monthlyTotals = [Double](repeating: 0, count: 12)
        
        // Initialize array that will say which harvests to keep
        var retain = [Bool](repeating: false, count: harvests.count)
        
        // Loop over harvests if there are harvests
        if(harvests.count > 0){
            
            for harvestIndex in 0...harvests.count - 1 {
                
                // Loop over tags if there are tags to filter by
                if(tags.count > 0) {
                    
                    // Loop over tags in harvest
                    
                    // Count number of tags on harvest of interest
                    let harvestTagCount = harvests[harvestIndex].tagArray?.count ?? 0
                    
                    if harvestTagCount > 0 {
                        
                        for tagIndex in 0...harvestTagCount - 1 {
                            
                            if let tag = harvests[harvestIndex].tagArray?[tagIndex] {
                                
                                if(tags.contains(tag)){
                                    retain[harvestIndex] = true
                                }
                            }
                        }
                    }
                    
                } else {
                    // If no tags to filter by, set all to be retained by filter
                    retain = [Bool](repeating: true, count: harvests.count)
                }
                
                // Add to montly total if retained after filtering
                if retain[harvestIndex] {
                    
                    // Extract year and month from harvest date, if harvest date exists
                    if let date = harvests[harvestIndex].harvestDate {
                        
                        let yearMonth = Calendar.current.dateComponents([.year, .month], from: date)
                        
                        if let month = yearMonth.month {
                            
                            // Add to monthly totals
                            monthlyTotals[month - 1] += harvests[harvestIndex].amountStandardized
                        }
                    } // end if date exists
                    
                } // end retain if
                
                
            } // End harvest loop
        } // End if harvests has elements
        
        let chartData = ChartData(values: [("J", monthlyTotals[0]),
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

