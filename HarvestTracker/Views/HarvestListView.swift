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
    
    // State variables
    @State var isPresented = false

    // Used to workaround bug that add button doesn't work if sheet has already been presented
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
    
        NavigationView {
        
          List {
            ForEach(harvests, id: \.self) {
              HarvestRowView(harvest: $0)
            }
            .onDelete(perform: deleteHarvest)
          }
            .sheet(isPresented: $isPresented) {
                    AddHarvestView(isPresented: self.$isPresented)
            .environment(\.managedObjectContext, self.managedObjectContext) // To get access to crops
                
          }
          .navigationBarTitle(Text("Harvests"))
          .navigationBarItems(leading: EditButton(),
            trailing:
                Button(action: { self.isPresented.toggle() }) {
                    Image(systemName: "plus")
                }
            )
        }
        .onAppear() {
            
            print("Navigation view appeared")
            
            if(self.harvests.count == 0){
                print("No harvests found")
                Harvest.addDefaultHarvests(in: self.managedObjectContext)
            }

            if(self.crops.count == 0){
                print("No crops found")
                Crop.loadDefaultCrops(in: self.managedObjectContext)
            }
        }
    }
    
    // Maybe there is a way to factor this out into Harvest, but not sure how
    func deleteHarvest(at offsets: IndexSet) {
      offsets.forEach { index in
        let harvest = self.harvests[index]
        Harvest.deleteHarvest(harvest: harvest, in: self.managedObjectContext)
      }
    }
    
}

