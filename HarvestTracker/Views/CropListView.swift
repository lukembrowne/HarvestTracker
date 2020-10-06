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
    @Binding var cropBeingEdited: Crop?
    
    @State var isPresentedAddCrop = false
    @State var isPresentedAddHarvest = false
    var cropEditMode: Bool
    @Binding var harvestEditMode: Bool

    
    // Set up three initializers
    
    // Basic initializer when adding a new harvest
    init(){
        self._harvestEditMode = Binding.constant(false)
        self._cropBeingEdited = Binding.constant(nil)
        self.cropEditMode = false
    }
    
    // Editing mode initializer when editing a harvest and choosing a new crop
    init(harvestEditMode: Binding<Bool>,
         cropBeingEdited: Binding<Crop?>){
        self._harvestEditMode = harvestEditMode
        self._cropBeingEdited = cropBeingEdited
        self.cropEditMode = false
    }
    
    // Editing mode intializer when editing the crop list directly
    init(cropEditMode: Bool){
        self.cropEditMode = cropEditMode
        self._harvestEditMode = Binding.constant(false)
        self._cropBeingEdited = Binding.constant(nil)
    }
    
    
    
    var body: some View {
        
        VStack {
            
            Text("Choose a crop")
                .font(.title)
            
            List {
                
                // Display crops in list
                ForEach(crops, id: \.self) { crop in
                    CropRowView(crop: crop,
                                chosenCrop: $chosenCrop,
                                cropBeingEdited: $cropBeingEdited,
                                isPresentedAddHarvest:  $isPresentedAddHarvest,
                                isPresentedAddCrop: $isPresentedAddCrop,
                                cropEditMode: cropEditMode,
                                harvestEditMode: $harvestEditMode)
                }
                .onDelete(perform: deleteCrop)
                
                
            } // list
            // Display addharvestview when crop is finally selected
            .sheet(isPresented: $isPresentedAddHarvest) {
                    AddHarvestView(chosenCrop: chosenCrop,
                                   isPresentedAddHarvest: $isPresentedAddHarvest,
                                   settings: settings)
                        .environment(\.managedObjectContext, self.managedObjectContext) // To get access to crops
            } // .sheet
            
            // Button to add new crop
            Button(action: {
                    self.isPresentedAddCrop = true
                
            },
                   label: {
                    Image(systemName: "plus")
                    Text("Add New Crop")
                   })
                .foregroundColor(Color.white)
                .padding()
                .background(Color.green)
                .cornerRadius(5)
                .sheet(isPresented: $isPresentedAddCrop) {
                    
                    if(cropEditMode) {
                        AddCropView(cropBeingEdited: self.$chosenCrop,
                                        inEditMode: true)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                        
                    } else {
                        AddCropView()
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    }
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

