//
//  AddCropView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/2/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct AddCropView: View {
    
    // Environment and bindings
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var settings: UserSettings
    
    @State var cropName: String = ""
    static let defaultCropName = "default new crop"
    
    @State var chosenUnit = "oz"
    var units = ["oz", "lb", "g", "kg"]
    
    @State var chosenCostPerUnit = ""
    static let defaultCostPerUnit = "1"
    
    var titleText = "Add Crop"
    
    @State var inEditMode = false
    @Binding var cropBeingEdited: Crop?
    @State var showingNoCropNameAlert = false
    
    
    init() {
        self._cropBeingEdited = Binding.constant(nil)
    }
    
    init(cropBeingEdited: Binding<Crop?>,
         inEditMode: Bool) {
        
        self._cropBeingEdited = cropBeingEdited
        self._inEditMode = State(initialValue: inEditMode)
        self.titleText = "Edit Crop"
        
    }
    
    
    var body: some View {
        
        
        NavigationView {
            
            Form {
                
                // Select Crop
                Section(header: Text("Crop")) {
                    
                    TextField("Crop Name", text: $cropName)
                        .introspectTextField { textField in
                            textField.becomeFirstResponder()
                        }
                    
                } // End select crop section
                .alert(isPresented: $showingNoCropNameAlert) {
                    Alert(title: Text("Crop name not entered"), message: Text("Please enter a crop name"), dismissButton: .default(Text("Got it!")))
                }
                
                // Enter amount
                Section(header: Text("Amount")) {
                    
                    TextField("Cost Per Unit", text: $chosenCostPerUnit)
                        .keyboardType(.decimalPad)
                    
                    
                    Picker("units", selection: $chosenUnit) {
                        ForEach(0 ..< units.count) { index in
                            Text(self.units[index])
                                .tag(self.units[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                
            }
            .navigationBarTitle(Text(titleText),
                                displayMode: .inline)
            .navigationBarItems(leading:
                                    
                                    // Add Cancel button
                                    Button(action: {
                                        print("tapped cancel")
                                        self.presentation.wrappedValue.dismiss()
                                    }, label: {
                                        Text("Cancel")
                                    }),
                                
                                trailing:
                                    
                                    Button(action: {
                                        
                                        // Check if crop name is entered
                                        if self.cropName.isEmpty {
                                            self.showingNoCropNameAlert = true
                                        } else {
                                            if(inEditMode){
                                                self.updateCropAction()
                                            } else {
                                                self.addCropAction()
                                            }
                                        }
                                    },
                                    label: {
                                        Image(systemName: "checkmark.circle")
                                        Text("Save")
                                    })
                                
            )
            
        } // End Navigation View
        // Need to set states on appearance of view bc setting these states in initializer was not working - work around for potential bug
        .onAppear {
            if(inEditMode) {
                self.cropName = cropBeingEdited?.cropName ?? ""
                self.chosenUnit = cropBeingEdited?.unit ?? settings.unitString
                if let cpu = cropBeingEdited?.costPerUnit {
                    self.chosenCostPerUnit = String("\(cpu)")
                }
            }
        }
    } // End body
    
    private func addCropAction() {
        
        // Add crop to database
        Crop.addCrop(cropName: cropName.isEmpty ? AddCropView.defaultCropName : cropName,
                     costPerUnit: chosenCostPerUnit.isEmpty ? AddCropView.defaultCostPerUnit : chosenCostPerUnit,
                     unit: chosenUnit,
                     in: self.managedObjectContext)
        // Close sheet
        self.presentation.wrappedValue.dismiss()
        
    }
    
    
    private func updateCropAction() {
        
        // Add crop to database
        Crop.updateCrop(crop: cropBeingEdited!,
                        cropName: cropName.isEmpty ? AddCropView.defaultCropName : cropName,
                        costPerUnit: chosenCostPerUnit.isEmpty ? AddCropView.defaultCostPerUnit : chosenCostPerUnit,
                        unit: chosenUnit,
                        in: self.managedObjectContext)
        // Close sheet
        self.presentation.wrappedValue.dismiss()
        
    }
    
}

