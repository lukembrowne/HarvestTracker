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
            
            ZStack {
                
                settings.bgColor.ignoresSafeArea() // to color in notch
                
                VStack {
                    
                    Text("Harvest Tracker")
                        .font(.largeTitle)
                        .padding([.top, .horizontal])
                        .foregroundColor(Color.white)
                    
                    // Add bar chart view
                    BarChartView(data: HarvestCalculator(harvests: harvests).calcTotalByMonth(filterByTags: [Tag]()))
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                            .foregroundColor(Color.white)
                            .shadow(radius: settings.cardShadowRadius)
                            
                        )
                        .padding(settings.cardPadding)
                    
                    
                    Text("Recent Harvests")
                        .font(.title)
                        .foregroundColor(Color.white)
                    
                    HarvestListView()
                        .frame(height: geometry.size.height * 0.6)
                        .cornerRadius(20)    
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                            .foregroundColor(Color.white)
                            .shadow(radius: settings.cardShadowRadius)
                        )
                        .padding([.bottom, .horizontal], settings.cardPadding)
                        .padding(.bottom, settings.cardPadding - 2)
                    
                }
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserSettings())
    }
}
