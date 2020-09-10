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
    @State var chosenCrop: Crop?
    static let defaultCrop = "default crop"
    
    @State var chosenAmount = ""
    static let defaultAmount = "1"

    @State var chosenHarvestDate = Date()
    
    @State var chosenUnit = "oz"
    var units = ["oz", "lb", "g", "kg"]
    
    @State var isPresentedAddCrop = false
    @State var showingAlert = false


    
    // Main view
    var body: some View {
        
      NavigationView {
        
        Form {
            
          // Select Crop
          Section(header: Text("Crop")) {

       // Testing
//       Button(action: { self.isPresentedAddCrop.toggle() }) {
//                           Text("Add New Crop")
//                         }.sheet(isPresented: $isPresentedAddCrop) {
//                         Text("Sheet to add new Crop")
//                         }
//
            NavigationLink(destination: CropListView(chosenCrop: $chosenCrop)) {
                HStack {
                    Text("Choose a crop:")
                    Spacer()
                    Text(chosenCrop?.cropName ?? "...")
                }
            }
            
          } // End select crop section
            
            

          // Enter amount
          Section(header: Text("Amount")) {
            
            TextField("Amount", text: $chosenAmount)
                .keyboardType(.decimalPad)
            
            Picker("units", selection: $chosenUnit) {
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
                    selection: $chosenHarvestDate,
                    displayedComponents: .date) { Text("Harvest Date").foregroundColor(Color(.gray)) }
            }
            
            // Add harvest button
            HStack {
                Spacer()
                Button(action: {
                    
                    if self.chosenCrop != nil {
                        self.addHarvestAction()
                        
                    } else {
                        print("Chosen crop is nil")
                        self.showingAlert.toggle()
                    }
                },
                       
                       
                       label: {
                        Image(systemName: "plus")
                        Text("Add Harvest")
                })
                    .foregroundColor(Color.white)
                    .padding()
                       .background(Color.green)
                       .cornerRadius(5)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("No crop chosen"), message: Text("Please choose a crop"), dismissButton: .default(Text("Got it!")))
                }
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
        Harvest.addHarvest(crop: chosenCrop,
                           amountEntered: chosenAmount.isEmpty ? AddHarvestView.defaultAmount : chosenAmount,
                           harvestDate: chosenHarvestDate,
                           unit: chosenUnit,
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
