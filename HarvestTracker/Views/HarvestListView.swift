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
    
    @State var isPresentedConfirmDelete = false
    @State private var deleteIndexSet: IndexSet?
    
    var body: some View {
        
        
        VStack {

            if(harvests.count == 0) {
                
                HStack {
                    Spacer()
                    Text("No harvests added yet!")
                    Spacer()
                }
                
            } else {
                
                List {
                    
                    ForEach(harvests, id: \.self) { harvest in
                        
                        HarvestRowView(harvest: harvest,
                                       chosenCrop: self.$chosenCrop,
                                       chosenHarvest: self.$chosenHarvest,
                                       isPresentedAddHarvest: $isPresentedEditHarvest)
                            .padding(3)
                    }
                    .onDelete(perform: { indexSet in
                        self.isPresentedConfirmDelete.toggle()
                        self.deleteIndexSet = indexSet
                    })
                    
                } // End List View
                // When harvest is tapped, open up editing mode
                .sheet(isPresented: $isPresentedEditHarvest) {
                    
                    AddHarvestView(harvest: $chosenHarvest,
                                   isPresentedAddHarvest: $isPresentedEditHarvest,
                                   settings: settings,
                                   inEditMode: true)
                        .environment(\.managedObjectContext, self.managedObjectContext) // To get access to crops
                } // .sheet
            } // if statement
        } // VStack
        .background(Color.white)
        .padding([.top, .bottom], settings.cardPadding)
        .onAppear() {
            
            if(self.crops.count == 0){
                print("No crops found")
                Crop.loadDefaultCrops(in: self.managedObjectContext)
            }
        } // End on Appear
        .actionSheet(isPresented: $isPresentedConfirmDelete) {
            
            let indexSet = self.deleteIndexSet!

            return ActionSheet(title: Text("Are you sure you want to delete this harvest?"), message: Text("The data will be lost forever!"),
                               buttons: [
                                .destructive(Text("Yes, please delete")) {
                                                self.deleteHarvest(at: indexSet)
                                            },
                                .cancel()
                               ])
        } // end action sheet
        
    } // End Body
    
    // Maybe there is a way to factor this out into Harvest, but not sure how
    func deleteHarvest(at offsets: IndexSet) {
        offsets.forEach { index in
            let harvest = self.harvests[index]
            Harvest.deleteHarvest(harvest: harvest, in: self.managedObjectContext)
        }
    }
    
}

