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
    
    
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            VStack {
                
                Text("Harvest Tracker")
                    .font(.largeTitle).fontWeight(.bold)
                    .padding()
                
                // Add total harvest amount
//                HarvestTotalView(harvests: harvests).environment(\.managedObjectContext, self.managedObjectContext)
//                    .frame(width: .infinity, height: geometry.size.height * 0.2, alignment: .center)
                
                Text("Total harvest \(HarvestCalculator(harvests: harvests).calcTotalHarvest())")
//
                BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]),
                             title: "Harvest total: 57.kg")
                
                HarvestListView()
                    .frame(width: .infinity, height: geometry.size.height * 0.66, alignment: .center)
                
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
