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
                    NSSortDescriptor(keyPath: \Crop.cropName, ascending: true)
                  ]) var crops: FetchedResults<Crop>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var chosenCrop: Crop?
    
    @State var isPresentedAddCrop = false
    @State var isPresentedAddHarvest = false


    
    
    var body: some View {
        
        NavigationView {
            
            List {
                
//                // Button to add new crop
//                Button(action: { self.isPresentedAddCrop.toggle() },
//                       label: {
//                        Image(systemName: "plus")
//                        Text("Add New Crop")
//                       })
//                    .foregroundColor(Color.white)
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(5)
//                    .sheet(isPresented: $isPresentedAddCrop) {
//                        AddCropView()
//                            .environment(\.managedObjectContext, self.managedObjectContext)
//                    }
                
                // Display crops in list
                ForEach(crops, id: \.self) { crop in
                    
//                    NavigationLink(
//
//                        destination: AddHarvestView(chosenCrop: $chosenCrop)
//
//                    ) {
                        CropRowView(crop: crop,
                                    chosenCrop: self.$chosenCrop,
                                    isPresentedAddHarvest:  $isPresentedAddHarvest)
                        
                    }
//                .isDetailLink(false)
                                }
            // Display addharvestview when crop is selected
            .sheet(isPresented: $isPresentedAddHarvest) {
                AddHarvestView(chosenCrop: $chosenCrop,
//                               isPresentedChooseCrop: $isPresentedChooseCrop,
                               isPresentedAddHarvest: $isPresentedAddHarvest)
                    .environment(\.managedObjectContext, self.managedObjectContext) // To get access to crops

            }
            
            .navigationBarTitle(Text("Choose crop"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                print("cancel pressed")
//                self.isPresentedChooseCrop = false
                
            }) {
                Text("Cancel")})

        } // End Navigation View
        
        
    }
}

