//
//  AddHarvest.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct AddHarvestView: View {
    
    // Environment and bindings
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var managedObjectContext

    @Binding var isPresented: Bool
    
    
    // Initialize and set defaults
    @State var crop = ""
    static let DefaultCrop = "default crop"
    
    @State var weight = ""
    static let DefaultWeight = "1"

    @State var harvestDate = Date()
    
    @State var unit = "oz"
    var units = ["oz", "lb", "g", "kg"]
    
    @State var isPresentedAddCrop = false

    // Fetch request for crops
    @FetchRequest(entity: Crop.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Crop.cropName, ascending: true)
                        ]) var crops: FetchedResults<Crop>
    
    
    // Main view
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
            
       // Testing
       Button(action: { self.isPresentedAddCrop.toggle() }) {
                           Text("Add New Crop")
                         }.sheet(isPresented: $isPresentedAddCrop) {
                         Text("Sheet to add new Crop")
                         }
            
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
            
        // Add Cancel button
        Button(action: {
            print("tapped cancel")
            self.presentation.wrappedValue.dismiss()
            self.isPresented = false
                            }, label: {
                                Text("Cancel")
                            }
                                )
                            )

      } // End Navigation View
    } // End Body
    
    
    //
    private func addHarvestAction() {
        
        // Add harvest to database
        Harvest.addHarvest(crop: crop.isEmpty ? AddHarvestView.DefaultCrop : crop,
                           weight: weight.isEmpty ? AddHarvestView.DefaultWeight : weight,
                           harvestDate: harvestDate,
                           unit: unit,
                           isPresented: $isPresented,
                           in: self.managedObjectContext)
        
        // Close sheet once harvest is added
        self.isPresented = false
      }
    
}





struct AddHarvestView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return AddHarvestView(isPresented: .constant(true)).environment(\.managedObjectContext, context)
    }
}
