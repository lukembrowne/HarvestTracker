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
    @State var isPresentedConfirmDelete = false
    @State private var deleteIndexSet: IndexSet?
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
        
        ZStack {
            
            settings.bgColor.ignoresSafeArea() // to color in notch
            
            VStack {
                                    
                    // Title
                    HStack {
                        
                        Text("Choose a crop")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            self.isPresentedAddCrop = true
                            
                        },
                        label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color.white)
                            Text("New crop")
                                .foregroundColor(Color.white)
                        })
                        .padding(settings.cardPadding - 2)
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
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                            .foregroundColor(settings.lightAccentColor)
                            .shadow(radius: settings.buttonShadowRadius)
                        )
                }
                
                // If no crops added yet
                if(crops.count == 0) {
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("No crops added yet!")
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .foregroundColor(Color.white)
                        .shadow(radius: settings.cardShadowRadius)
                    )
                    
                } else {
                
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
                    .onDelete(perform: { indexSet in
                        self.isPresentedConfirmDelete.toggle()
                        self.deleteIndexSet = indexSet
                    })
                    
                } // list
                // Display addharvestview when crop is finally selected
                .sheet(isPresented: $isPresentedAddHarvest) {
                    AddHarvestView(chosenCrop: chosenCrop,
                                   isPresentedAddHarvest: $isPresentedAddHarvest,
                                   settings: settings)
                        .environment(\.managedObjectContext, self.managedObjectContext) // To get access to crops
                } // .sheet
                .cornerRadius(20)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20
                    )
                    .foregroundColor(Color.white)
                    .shadow(radius: settings.cardShadowRadius)
                )

                } // End if statement
            } // vstack
            .navigationBarTitle("", displayMode: .inline) // Avoid large white space if viewing from Settings
            .padding(settings.cardPadding)
            .padding(.bottom, settings.cardPadding - 2)
        } // ZStack
        .actionSheet(isPresented: $isPresentedConfirmDelete) {
            
            let indexSet = self.deleteIndexSet!
            let crop = self.crops[indexSet.first ?? 0] // is this a dangerous potential for a bug?

            return ActionSheet(title: Text("Are you sure you want to delete \(crop.cropName!)?"), message: Text("Any harvests from this crop will no longer be associated with any crop!"),
                               buttons: [
                                .destructive(Text("Yes, delete \(crop.cropName!)")) {
                                                self.deleteCrop(at: indexSet)
                                            },
                                .cancel()
                               ])
        } // end action sheet
        
        
    } // view
    
    // Maybe there is a way to factor this out into Crop, but not sure how
    func deleteCrop(at offsets: IndexSet) {
        
        offsets.forEach { index in
            let crop = self.crops[index]
            Crop.deleteCrop(crop: crop, in: self.managedObjectContext)
        }
        
        
    }
}

