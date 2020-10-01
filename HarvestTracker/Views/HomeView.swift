//
//  HomeView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/18/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    
    // Fetch Harvests
    @FetchRequest(entity: Harvest.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Harvest.harvestDate, ascending: false)]
    ) var harvests: FetchedResults<Harvest>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var settings: UserSettings


    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            VStack {
                
                Text("Harvest Tracker")
                    .font(.largeTitle).fontWeight(.bold)
                    .padding()
 
                // Add bar chart view
                BarChartView(data: HarvestCalculator(settings: settings, harvests: harvests).calcTotalByMonth(),
                             title: "2019 total: \(HarvestCalculator(settings: settings, harvests: harvests).calcTotalHarvest().rounded(toPlaces: 2))")
                
                HarvestListView()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.66, alignment: .center)
                
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserSettings())
    }
}
