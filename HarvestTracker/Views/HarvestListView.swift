//
//  HarvestListView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct HarvestListView: View {
    
    
    // Fetch Harvests
    @FetchRequest(entity: Harvest.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Harvest.harvestDate, ascending: false)]
    ) var harvests: FetchedResults<Harvest>
    
    
    // Retrieve crops from database
    // Do I really need to have Crops in this view?
    @FetchRequest(entity: Crop.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Crop.cropName, ascending: true)
                        ]) var crops: FetchedResults<Crop>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    // Used to workaround bug that add button doesn't work if sheet has already been presented
    @Environment(\.presentationMode) var presentation
    
    
    // State variables
    @State var isPresented = false

    var body: some View {
    
        
        VStack {
            
            
            Button(action: {print(harvests)}, label: {Text("Print harvests")})

            
            Text("Recent Harvests")
                .font(.title)
            
              List {
                
                ForEach(harvests, id: \.self) {
                  HarvestRowView(harvest: $0)
                }
                .onDelete(perform: deleteHarvest)

            } // End List View
            .onAppear() {
                
                // To remove lines between rows of list
                 UITableView.appearance().separatorStyle = .none
                
                if(self.crops.count == 0){
                    print("No crops found")
                    Crop.loadDefaultCrops(in: self.managedObjectContext)
                }
            } // End on Appear
            
        }

    } // End Body
    
    // Maybe there is a way to factor this out into Harvest, but not sure how
    func deleteHarvest(at offsets: IndexSet) {
      offsets.forEach { index in
        let harvest = self.harvests[index]
        Harvest.deleteHarvest(harvest: harvest, in: self.managedObjectContext)
      }
    }
    
}

