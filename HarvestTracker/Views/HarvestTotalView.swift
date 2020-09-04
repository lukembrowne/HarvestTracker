//
//  HarvestTotalView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/3/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct HarvestTotalView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext

    var totalHarvestAmount = 0.0
    
    init(harvests: FetchedResults<Harvest> ){
        self.harvests = harvests
        calcTotalHarvest()

    }
    
   var harvests: FetchedResults<Harvest>
    
    
    var body: some View {
        Text("Total Harvest: \(self.totalHarvestAmount, specifier: "%.2f") kg")
        
    }
    

    // Calculate total Harvest
    mutating func calcTotalHarvest() {
        
        if(harvests.count > 0){
            for index in 0...harvests.count - 1 {
//                print(index)
                totalHarvestAmount += harvests[index].amountStandardized
            }
        } else {
            totalHarvestAmount = 0.0
        }
        
        // Convert to unit
        totalHarvestAmount = Measurement(value: totalHarvestAmount, unit: UnitMass.grams).converted(to: .kilograms).value
        
    }
    
    
    
    
}

//struct HarvestTotalView_Previews: PreviewProvider {
//    static var previews: some View {
//        HarvestTotalView()
//    }
//}
