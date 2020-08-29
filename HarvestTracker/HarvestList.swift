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
        NSSortDescriptor(keyPath: \Harvest.crop, ascending: false)
      ]
    // 4
    ) var harvests: FetchedResults<Harvest>

    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isPresented = false

    
    
    var body: some View {
        
        NavigationView {
          List {
            ForEach(harvests, id: \.crop) {
              HarvestRow(harvest: $0)
            }
            .onDelete(perform: deleteHarvest)
          }
          .sheet(isPresented: $isPresented) {
            AddHarvest { crop, weight, harvestDate in
                self.addHarvest(crop: crop, weight: weight, harvestDate: harvestDate)
              self.isPresented = false
            }
          }
          .navigationBarTitle(Text("Harvests"))
            .navigationBarItems(trailing:
              Button(action: { self.isPresented.toggle() }) {
                Image(systemName: "plus")
              }
          )
        }
    }
    
    
    func deleteHarvest(at offsets: IndexSet) {
      // 1
      offsets.forEach { index in
        // 2
        let harvest = self.harvests[index]
        // 3
        self.managedObjectContext.delete(harvest)
      }
      // 4
      saveContext()
    }
    
    func addHarvest(crop: String, weight: String, harvestDate: Date) {
      // 1
      let newHarvest = Harvest(context: managedObjectContext)

      // 2
      newHarvest.crop = crop
      newHarvest.weight = weight
      newHarvest.harvestDate = harvestDate

      // 3
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

