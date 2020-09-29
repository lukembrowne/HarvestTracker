//
//  AddHarvest.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import Introspect

struct AddHarvestView: View {
    
    // Environment and bindings
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var settings: UserSettings
   
    // Fetch requests
    @FetchRequest(entity: Tag.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(
                        key: "tagName",
                        ascending: true,
                        selector: #selector(NSString.caseInsensitiveCompare(_:))) // To make case insensitive
                  ]) var tags: FetchedResults<Tag>
    
    // Initialize and set defaults
    @Binding var chosenCrop: Crop?
    static let defaultCrop = "default crop"
    
    @State var chosenAmount = ""
    static let defaultAmount = "1"

    @State var chosenHarvestDate = Date()
    
    @State var chosenUnit: String
    var units = ["oz", "lb", "g", "kg"]
    
    @State var showingNoCropAlert = false
    @State var isPresentedAddCrop = false
    @Binding var isPresentedAddHarvest: Bool

    init(chosenCrop: Binding<Crop?>,
         isPresentedAddHarvest: Binding<Bool>, settings: UserSettings) {
                
        self._chosenCrop = chosenCrop
        self._isPresentedAddHarvest = isPresentedAddHarvest
        self._chosenUnit = State(initialValue: settings.unitString)

    }

    
    // Main view
    var body: some View {
                
        Form {
            
          // Select Crop
          Section(header: Text("Crop")) {

            Button {
                self.isPresentedAddHarvest = false
            } label: {
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
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .introspectTextField { textField in
                   textField.becomeFirstResponder()
            }

            
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
                    displayedComponents: .date) {
                    Text("Harvest Date").foregroundColor(Color(.gray))
                }
                .datePickerStyle(DefaultDatePickerStyle())
            }
            
            // Add tags
            
            Section {
                
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag.tagName ?? "no name")
                    }
                }
              
                
            }
            
            
            // Add harvest button
            HStack {
                Spacer()
                Button(action: {
                    
                    if self.chosenCrop != nil {
                        self.addHarvestAction()
                        
                    } else {
                        print("Chosen crop is nil")
                        self.showingNoCropAlert.toggle()
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
                .alert(isPresented: $showingNoCropAlert) {
                    Alert(title: Text("No crop chosen"), message: Text("Please choose a crop"), dismissButton: .default(Text("Got it!")))
                }
               Spacer()
            }   

           
        }
//        .navigationBarTitle(Text("Add Harvest"), displayMode: .inline)
//        .navigationBarItems(leading:
//
//            // Add Cancel button
//            Button(action: {
//                print("tapped cancel")
//                self.presentation.wrappedValue.dismiss()
////                self.isPresentedChooseCrop = false
//
//                self.isPresentedAddHarvest = false
//                                }, label: {
//                                    Text("Cancel")
//                                }
//                                    )
//                                )
    } // End Body
    
    
    //
    private func addHarvestAction() {
        
        // Add harvest to database
        Harvest.addHarvest(crop: chosenCrop,
                           amountEntered: chosenAmount.isEmpty ? AddHarvestView.defaultAmount : chosenAmount,
                           harvestDate: chosenHarvestDate,
                           unit: chosenUnit,
                           tag: tags[0],
                           isPresented: $isPresentedAddHarvest,
                           in: self.managedObjectContext)
        
        // Close sheet once harvest is added
        self.isPresentedAddHarvest = false
//        self.isPresentedChooseCrop = false
//        self.presentation.wrappedValue.dismiss()

      }
    
}

//struct AddHarvestView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        return AddHarvestView(isPresented: .constant(true)).environment(\.managedObjectContext, context)
//    }
//}
