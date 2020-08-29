//
//  AddHarvest.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct AddHarvest: View {
    
    static let DefaultCrop = "default crop"
    static let DefaultWeight = "1"

    @State var crop = ""
    @State var weight = ""
    @State var harvestDate = Date()
    let onComplete: (String, String, Date) -> Void

    var body: some View {
      NavigationView {
        Form {
          Section(header: Text("Crop")) {
            TextField("Crop", text: $crop)
          }
          Section(header: Text("Weight")) {
            TextField("Weight", text: $weight)
          }
          Section {
            DatePicker(
              selection: $harvestDate,
              displayedComponents: .date) { Text("Harvest Date").foregroundColor(Color(.gray)) }
          }
          Section {
            Button(action: addHarvestAction) {
              Text("Add Harvest")
            }
          }
        }
        .navigationBarTitle(Text("Add Harvest"), displayMode: .inline)
      }
    }

    private func addHarvestAction() {
      onComplete(
        crop.isEmpty ? AddHarvest.DefaultCrop : crop,
        weight.isEmpty ? AddHarvest.DefaultWeight : weight,
        harvestDate)
    }
}

