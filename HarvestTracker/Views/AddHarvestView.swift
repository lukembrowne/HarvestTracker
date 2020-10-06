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
    @State var chosenCrop: Crop?
    @Binding var chosenHarvest: Harvest?
    
    @State var chosenAmount = ""
    static let defaultAmount = "1"
    
    @State var chosenHarvestDate = Date()
    
    @State var chosenUnit: String
    var units = ["oz", "lb", "g", "kg"]
    
    @State var chosenTags = [Tag]()
    
    @State var showingNoCropAlert = false
    @State var isPresentedCropList = false
    @Binding var isPresentedAddHarvest: Bool
    @State var inEditMode = false
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    // Regular init
    init(chosenCrop: Crop?,
         isPresentedAddHarvest: Binding<Bool>,
         settings: UserSettings) {
        
        self._chosenCrop = State(initialValue: chosenCrop)
        self._isPresentedAddHarvest = isPresentedAddHarvest
        self._chosenUnit = State(initialValue: settings.unitString)
        self._chosenHarvest = Binding.constant(nil)
        
    }
    
    // Entering edit mode from tapping on harvest list row
    init(harvest: Binding<Harvest?>,
         isPresentedAddHarvest: Binding<Bool>,
         settings: UserSettings,
         inEditMode: Bool){
        
        self._chosenHarvest = harvest
        self._isPresentedAddHarvest = isPresentedAddHarvest
        self._chosenUnit = State(initialValue: harvest.wrappedValue?.unitEntered ?? settings.unitString)
        self._inEditMode = State(initialValue: inEditMode)
    }
    
    
    
    
    // Main view
    var body: some View {
        
        VStack{
            
            // Title bar with cancel button
            ZStack{
                HStack{
                    Button(action: {
                        self.isPresentedAddHarvest.toggle()
                    }, label: {
                        Text("Cancel")
                        
                    })
                    Spacer()
                    
                }
                
                HStack{
                    if(inEditMode) {
                        Text("Edit harvest")
                            .font(.headline)
                    } else {
                        Text("Add a new harvest")
                            .font(.headline)
                    }
                }
            }.padding()
            
            
            // Begin form
            Form {
                
                // Select Crop
                Section(header: Text("Crop")) {
                    
                    // If in edit mode, when crop is selected, navigate to crop list view
                    if(inEditMode) {
                        Button {
                            self.isPresentedCropList = true
                        } label: {
                            HStack {
                                Text("Choose a crop:")
                                Spacer()
                                Text(chosenCrop?.cropName ?? "...")
                            }
                        }
                        .sheet(isPresented: $isPresentedCropList) {
                            
                            CropListView(harvestEditMode: $inEditMode,
                                         cropBeingEdited: $chosenCrop).environment(\.managedObjectContext, self.managedObjectContext)
                        }// .sheet
                        
                    } else {
                        // If not in edit mode, when crop is selected, close sheet because that returns to crop list view
                        Button {
                            self.isPresentedAddHarvest = false
                        } label: {
                            HStack {
                                Text("Choose a crop:")
                                Spacer()
                                Text(chosenCrop?.cropName ?? "...")
                            }
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
                
                // Add tags to harvest
                Section {
                    
                    HStack {
                        ForEach(tags, id: \.self) { tag in
                            
                            TagView(tag: tag,
                                    chosenTags: $chosenTags)
                        }
                        
                    }
                    
                    // Testing
                    Button(action: {print(chosenTags)}, label: {Text("Print chosen tags")})
                    
                    
                }
                
                Section {
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(tags, id: \.self) { tag in
                                TagView(tag: tag,
                                        chosenTags: $chosenTags)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    
                }
                
                
                // Add harvest button
                HStack {
                    Spacer()
                    Button(action: {
                        
                        if self.chosenCrop != nil {
                            
                            if(inEditMode){
                                self.updateHarvestAction()
                            } else {
                                self.addHarvestAction()
                            }
                            
                        } else {
                            print("Chosen crop is nil")
                            self.showingNoCropAlert.toggle()
                        }
                    },
                    label: {
                        
                        if(inEditMode){
                            Image(systemName: "checkmark.circle")
                            Text("Save edits")
                        } else {
                            Image(systemName: "plus")
                            Text("Add Harvest")
                        }

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
            .navigationBarItems(leading:
                                    // Add Cancel button
                                    Button(action: {
                                        print("tapped cancel")
                                        self.presentation.wrappedValue.dismiss()
                                        //                self.isPresentedChooseCrop = false
                                        
                                        self.isPresentedAddHarvest = false
                                    }, label: {
                                        Text("Cancel")
                                    }
                                    )
            )
            
        }
        // Need to set states on appearance of view bc setting these states in initializer was not working - work around for potential bug
        .onAppear {
            
            if(inEditMode){
                
                
                self.chosenCrop = chosenHarvest?.crop
                if let amount = chosenHarvest?.amountEntered {
                    self.chosenAmount = String("\(amount)")
                }
                self.chosenHarvestDate = chosenHarvest?.harvestDate ?? Date()
                self.chosenTags = chosenHarvest?.tagArray ?? [Tag]()
                self.chosenUnit = chosenHarvest?.unitEntered ?? settings.unitString
                
            }
        }
    } // End Body
    
    
    //
    private func addHarvestAction() {
        
        // Add harvest to database
        Harvest.addHarvest(crop: chosenCrop,
                           amountEntered: chosenAmount.isEmpty ? AddHarvestView.defaultAmount : chosenAmount,
                           harvestDate: chosenHarvestDate,
                           unit: chosenUnit,
                           chosenTags: chosenTags,
                           isPresented: $isPresentedAddHarvest,
                           in: self.managedObjectContext)
        
        // Close sheet once harvest is added
        self.isPresentedAddHarvest = false
        //        self.isPresentedChooseCrop = false
        //        self.presentation.wrappedValue.dismiss()
        
    }
    
    private func updateHarvestAction() {
        
        // Add harvest to database
        Harvest.updateHarvest(harvest: chosenHarvest!,
                              crop: chosenCrop,
                              amountEntered: chosenAmount.isEmpty ? AddHarvestView.defaultAmount : chosenAmount,
                              harvestDate: chosenHarvestDate,
                              unit: chosenUnit,
                              chosenTags: chosenTags,
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
