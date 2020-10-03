//
//  CropListView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/2/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct CropListView: View {
    
    
    // Fetch request for crops
    @FetchRequest(entity: Crop.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(
                        key: "cropName",
                        ascending: true,
                        selector: #selector(NSString.caseInsensitiveCompare(_:))) // To make case insensitive
                  ]) var crops: FetchedResults<Crop>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var settings: UserSettings
    
    @State var chosenCrop: Crop?
    
    @State var isPresentedAddCrop = false
    @State var isPresentedAddHarvest = false
    
    
    
    var body: some View {
        
        
        VStack {
            
            Text("Choose a crop")
                .font(.title)
            
            List {
                
                // Display crops in list
                ForEach(crops, id: \.self) { crop in
                    CropRowView(crop: crop,
                                chosenCrop: self.$chosenCrop,
                                isPresentedAddHarvest:  $isPresentedAddHarvest)
                    
                }
                .onDelete(perform: deleteCrop)
                
                
            } // list
            // Display addharvestview when crop is selected
            .sheet(isPresented: $isPresentedAddHarvest) {
                AddHarvestView(chosenCrop: $chosenCrop,
                               //                               isPresentedChooseCrop: $isPresentedChooseCrop,
                               isPresentedAddHarvest: $isPresentedAddHarvest,
                               settings: settings)
                    .environment(\.managedObjectContext, self.managedObjectContext) // To get access to crops
                
            } // .sheet
            
            // Button to add new crop
            Button(action: { self.isPresentedAddCrop.toggle()},
                   label: {
                    Image(systemName: "plus")
                    Text("Add New Crop")
                   })
                .foregroundColor(Color.white)
                .padding()
                .background(Color.green)
                .cornerRadius(5)
                .sheet(isPresented: $isPresentedAddCrop) {
                    AddCropView()
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
            
            
        } // vstack
        .padding()
        
    } // view
    
    // Maybe there is a way to factor this out into Crop, but not sure how
    func deleteCrop(at offsets: IndexSet) {
        offsets.forEach { index in
            let crop = self.crops[index]
            Crop.deleteCrop(crop: crop, in: self.managedObjectContext)
        }
    }
}

