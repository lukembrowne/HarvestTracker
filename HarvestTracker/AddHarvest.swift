//
//  AddHarvest.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct AddHarvest: View {
    
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var managedObjectContext


    @Binding var isPresented: Bool
    
    static let DefaultCrop = "default crop"
    static let DefaultWeight = "1"

    @State var crop = ""
    @State var weight = ""
    @State var harvestDate = Date()
    
    @State var unit = "oz"
    var units = ["oz", "lb", "g", "kg"]
        
    @FetchRequest(entity: Crop.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Crop.cropName, ascending: true)
                        ]) var crops: FetchedResults<Crop>
    

    let onComplete: (String, String, Date, String, Binding<Bool>) -> Void

    var body: some View {
      NavigationView {
        Form {
            
            
          // Select Crop
          Section(header: Text("Crop")) {
            Picker("Choose a crop:", selection: $crop) {
                           ForEach(0 ..< crops.count) { index in
                            Text(self.crops[index].cropName ?? "")
                                .tag(self.crops[index].cropName ?? "" )
                           }
            }.environment(\.managedObjectContext, self.managedObjectContext)
          }

          // Enter weight
          Section(header: Text("Amount")) {
            TextField("Weight", text: $weight)
                .keyboardType(.decimalPad)
            Picker("units", selection: $unit) {
                ForEach(0 ..< units.count) { index in
                    Text(self.units[index])
                        .tag(self.units[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
          }
            
          // Enter harvest date
          Section {
            DatePicker(
              selection: $harvestDate,
              displayedComponents: .date) { Text("Harvest Date").foregroundColor(Color(.gray)) }
            }

           // Add harvest button
            HStack {
               Spacer()
               Button(action: addHarvestAction, label: {
                   Image(systemName: "plus")
                   Text("Add Harvest")
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
            Button(action: {
                print("tapped cancel")
                self.presentation.wrappedValue.dismiss()
                self.isPresented = false
                                }, label: {
                                    Text("Cancel")
                                }
                                    )
                                )

        }
    }
    
    private func addHarvestAction() {
      onComplete(
        crop.isEmpty ? AddHarvest.DefaultCrop : crop,
        weight.isEmpty ? AddHarvest.DefaultWeight : weight,
        harvestDate,
        unit,
        $isPresented)
    }
}

