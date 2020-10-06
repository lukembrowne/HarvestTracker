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
    @EnvironmentObject var settings: UserSettings

    
  
    // State variables
    @State var isPresentedEditHarvest = false
    @State var chosenHarvest: Harvest?
    @State var chosenCrop: Crop?

    var body: some View {
    
        
        VStack {
            
            
            Button(action: {print(harvests)}, label: {Text("Print harvests")})

            
            Text("Recent Harvests")
                .font(.title)
            
            // Testing
            Button(action: {print(self.chosenHarvest)}, label: {Text("Print chosen harvest")})
            
              List {
                
                ForEach(harvests, id: \.self) { harvest in
                    
                    HarvestRowView(harvest: harvest,
                                   chosenCrop: self.$chosenCrop,
                                   chosenHarvest: self.$chosenHarvest,
                                   isPresentedAddHarvest: $isPresentedEditHarvest)
                }
                .onDelete(perform: deleteHarvest)
       

            } // End List View
              // When harvest is tapped, open up editing mode
              .sheet(isPresented: $isPresentedEditHarvest) {

                  AddHarvestView(harvest: $chosenHarvest,
                                 isPresentedAddHarvest: $isPresentedEditHarvest,
                                 settings: settings,
                                 inEditMode: true)
                      .environment(\.managedObjectContext, self.managedObjectContext) // To get access to crops
              }// .sheet
            .onAppear() {
                
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

