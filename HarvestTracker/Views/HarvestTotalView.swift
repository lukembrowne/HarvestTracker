//
//  HarvestTotalView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/3/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import CoreData

struct HarvestTotalView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext

    var harvests: FetchedResults<Harvest>
    var totalHarvestAmount = 0.0
    var currencyFormatter = NumberFormatter()
    var totalHarvestValue = 0.0
    var totalHarvestValueDisplay = ""
    
    init(harvests: FetchedResults<Harvest> ){
        self.harvests = harvests
        self.currencyFormatter.usesGroupingSeparator = true
        self.currencyFormatter.numberStyle = .currency
        self.currencyFormatter.locale = Locale.current
        calcTotalHarvest()
        
    }
    
    
    
    var body: some View {
        
        
        ZStack {
            
            HStack {
                
                // Total harvest amount
                VStack {
                    Text("Total Harvest")
                        .font(.title)
                    HStack {
                        Text("\(self.totalHarvestAmount, specifier: "%.2f")")
                            .font(.largeTitle)
                        Text("kg")
                            .font(.caption)
                    }
                }
                            
                // Total harvest value
                VStack {
                    Text("Total Value")
                        .font(.title)
                    
                    Text("\(self.totalHarvestValueDisplay)")
                        .font(.largeTitle)
                }
            }
            .foregroundColor(Color.white)
            
        }
        
        
        
        
    }
    
    
    // Calculate total Harvest
    mutating func calcTotalHarvest() {
        
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
        
        // Calculate value
        totalHarvestValueDisplay = currencyFormatter.string(from: NSNumber(value: totalHarvestValue)) ?? ""
        
    }
    
    
    
    
}

//struct HarvestTotalView_Previews: PreviewProvider {
//    
//    
//    // Fetch Harvests
//    @FetchRequest(entity: Harvest.entity(),
//                  sortDescriptors: [NSSortDescriptor(keyPath: \Harvest.harvestDate, ascending: false)]
//    ) static var harvests: FetchedResults<Harvest>
//          
//    
//    static var previews: some View {
//        
//        
//        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        
//  
//        HarvestTotalView(harvests: harvests).environment(\.managedObjectContext, moc)
//    }
//}
