//
//  HomeView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/18/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    
    
    // Fetch Harvests
    @FetchRequest(entity: Harvest.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Harvest.harvestDate, ascending: false)]
    ) var harvests: FetchedResults<Harvest>
    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var defaultUnit: DefaultUnit
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            VStack {
                
                Text("Harvest Tracker")
                    .font(.largeTitle).fontWeight(.bold)
                    .padding()
                
                // Add total harvest amount
//                HarvestTotalView(harvests: harvests).environment(\.managedObjectContext, self.managedObjectContext)
//                    .frame(width: .infinity, height: geometry.size.height * 0.2, alignment: .center)
 
                // Add bar chart view
                BarChartView(data: HarvestCalculator(harvests: harvests).calcTotalByMonth(),
                             title: "2019 total: \(HarvestCalculator(harvests: harvests).calcTotalHarvest().rounded(toPlaces: 2))", defaultUnit: defaultUnit)
                    .onAppear(perform: {
                        print("Default unit when barchartview appears is \(defaultUnit.unitString)")
                    })

                
                HarvestListView()
                    .frame(width: .infinity, height: geometry.size.height * 0.66, alignment: .center)
                
            }
        }
    }
}

//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
