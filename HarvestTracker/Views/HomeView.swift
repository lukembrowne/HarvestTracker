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
    
    
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            VStack {
                
                Text("Harvest Tracker")
                    .font(.largeTitle).fontWeight(.bold)
                    .padding()
                
                // Add total harvest amount
                HarvestTotalView(harvests: harvests).environment(\.managedObjectContext, self.managedObjectContext)
                    .frame(width: .infinity, height: geometry.size.height * 0.2, alignment: .center)
                
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
