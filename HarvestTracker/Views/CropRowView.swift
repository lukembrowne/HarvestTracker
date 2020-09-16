//
//  CropRowView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/2/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct CropRowView: View {
    
    var crop: Crop
    @Binding var chosenCrop: Crop?
    @Binding var isPresentedAddHarvest: Bool
    @Binding var isPresentedChooseCrop: Bool

    
    var body: some View {
        
        HStack {
            Image(systemName: "sun.max")
            Text(verbatim: crop.cropName ?? "")
            Spacer()
        }.onTapGesture {
            self.chosenCrop = self.crop
            self.isPresentedChooseCrop = false
            self.isPresentedAddHarvest = true
        }
    }
}
