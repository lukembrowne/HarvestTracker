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
    
    
    // UI settings
    let shadowRadius = CGFloat(2)
    
    
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            VStack {
                
                Text("Harvest Tracker")
                    .font(.largeTitle).fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.white)
                
                // Add bar chart view
                BarChartView(data: HarvestCalculator(settings: settings, harvests: harvests).calcTotalByMonth(),
                             title: "2019 total: \(HarvestCalculator(settings: settings, harvests: harvests).calcTotalHarvest().rounded(toPlaces: 2))")
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .foregroundColor(Color.white)
                        .shadow(radius: shadowRadius)
                        
                    )
                    .padding(8)
                
                
                HarvestListView()
                    .frame(height: geometry.size.height * 0.6)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .foregroundColor(Color.white)
                        .shadow(radius: shadowRadius)
                    )
                    .padding(8)
                
            }
            .background(Color.green)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserSettings())
    }
}
