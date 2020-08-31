//
//  HarvestList.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct HarvestList: View {
    
    
    // 1
    @FetchRequest(
      // 2
      entity: Harvest.entity(),
      // 3
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Harvest.harvestDate, ascending: false)
      ]
    // 4
    ) var harvests: FetchedResults<Harvest>
    
    
    // Retrieve crops from database
    @FetchRequest(entity: Crop.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Crop.cropName, ascending: true)
                        ]) var crops: FetchedResults<Crop>


    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isPresented = false
    
    // Used to workaround bug that add button doesn't work if sheet has already been presented
    @Environment(\.presentationMode) var presentation


    var body: some View {
        
        NavigationView {
          List {
            ForEach(harvests, id: \.self) {
              HarvestRow(harvest: $0)
            }
            .onDelete(perform: deleteHarvest)
          }
          .sheet(isPresented: $isPresented) {
            AddHarvest(isPresented: self.$isPresented) { crop,
                weight,
                harvestDate,
                unit,
                isPresented in
              self.addHarvest(crop: crop,
                              weight: weight,
                              harvestDate: harvestDate,
                              unit: unit,
                              isPresented: self.$isPresented)
              self.isPresented = false
            }
            .environment(\.managedObjectContext, self.managedObjectContext) // To get access to crops

          }
          .navigationBarTitle(Text("Harvests"))
            .navigationBarItems(trailing:
              Button(action: { self.isPresented.toggle() }) {
                Image(systemName: "plus")
              }
          )
        }
        .onAppear() {
            print("Navigation view appeared")
            if(self.harvests.count == 0){
                print("No harvests found")
                self.loadDefaultHarvests()
            }
            
            if(self.crops.count == 0){
                print("No crops found")
                self.loadDefaultCrops()
            }
        }
    }
    
    
    func deleteHarvest(at offsets: IndexSet) {
      offsets.forEach { index in
        let harvest = self.harvests[index]
        self.managedObjectContext.delete(harvest)
      }
      saveContext()
    }
    
    func addHarvest(crop: String,
                    weight: String,
                    harvestDate: Date,
                    unit: String,
                    isPresented: Binding<Bool>) {
      // 1
      let newHarvest = Harvest(context: managedObjectContext)

      // 2
      newHarvest.crop = crop
      newHarvest.weight = Double(weight) ?? 0.0
      newHarvest.harvestDate = harvestDate
      newHarvest.unit = unit
        
    //  print(newHarvest)
        Harvest.printHarvest()

      // 3
      saveContext()
    }
    
    func loadDefaultHarvests() {
        
        let newHarvest = Harvest(context: managedObjectContext)
              
        newHarvest.crop = "default harvest init"
        newHarvest.weight = 420
        
        saveContext()
        
    }
    
    func loadDefaultCrops() {
          
        for crop in cropsJSONDecoded {
            let newCrop = Crop(context: managedObjectContext)
                   
            newCrop.cropName = crop.cropName
            newCrop.costPerUnit = crop.costPerUnit
            newCrop.unit = crop.unit
        }
        
        
              
          saveContext()
          
      }
    
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    
}

