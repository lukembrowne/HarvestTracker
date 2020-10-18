//
//  CropRowView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/2/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct CropRowView: View {
    
    @Environment(\.presentationMode) var presentationMode

    
    var crop: Crop
    @Binding var chosenCrop: Crop?
    @Binding var cropBeingEdited: Crop?
    @Binding var isPresentedAddHarvest: Bool
    @Binding var isPresentedAddCrop: Bool
    var cropEditMode: Bool
    @Binding var harvestEditMode: Bool
    
    var body: some View {
        
        HStack {
            Image(systemName: "chevron.right.circle")
            Text(verbatim: crop.cropName ?? "")
            Spacer()
        }.onTapGesture {
            self.chosenCrop = self.crop
            if(harvestEditMode) {self.cropBeingEdited = self.crop}

            // If in editmode, dismiss sheet and return to edit harvest, or else navigate to add harvest sheet
            if(harvestEditMode) {
                self.presentationMode.wrappedValue.dismiss()
            } else if(cropEditMode){
                self.isPresentedAddCrop = true
            } else {
                self.isPresentedAddHarvest = true
            }
        }
    }
}
