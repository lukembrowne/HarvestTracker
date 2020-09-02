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
    
    @State var cropName: String = ""
    static let defaultCropName = "default new crop"
    
    @State var chosenUnit = "oz"
    var units = ["oz", "lb", "g", "kg"]
    
    @State var chosenCostPerUnit = ""
    static let defaultCostPerUnit = "1"
    
    
    
    
    var body: some View {
        NavigationView {
            
            Form {
                
                // Select Crop
                Section(header: Text("Crop")) {
                    
                    TextField("Crop Name", text: $cropName)
                    
                } // End select crop section
                
                
                // Enter weight
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
                
                
                
                // Add crop button
                HStack {
                    Spacer()
                    Button(action: addCropAction, label: {
                        Image(systemName: "plus")
                        Text("Add Crop")
                    })
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(5)
                    Spacer()
                }
                
            }
            .navigationBarTitle(Text("Add Harvest"), displayMode: .inline)
            .navigationBarItems(leading:
                
                // Add Cancel button
                Button(action: {
                    print("tapped cancel")
                    self.presentation.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }
                )
            )
            
        } // End Navigation View
    } // End body
    
    private func addCropAction() {
        
        print("Add crop button pressed")
        
        
        // Add crop to database
        Crop.addCrop(cropName: cropName.isEmpty ? AddCropView.defaultCropName : cropName,
                     costPerUnit: chosenCostPerUnit.isEmpty ? AddCropView.defaultCostPerUnit : chosenCostPerUnit,
                     unit: chosenUnit,
                     in: self.managedObjectContext)
        
        // Close sheet
        self.presentation.wrappedValue.dismiss()
        
        
    }
}

