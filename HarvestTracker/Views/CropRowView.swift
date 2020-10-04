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
    @Binding var inEditMode: Bool
    
    var body: some View {
        
        HStack {
            Image(systemName: "sun.max")
            Text(verbatim: crop.cropName ?? "")
            Spacer()
        }.onTapGesture {
            self.chosenCrop = self.crop
            if(inEditMode) {self.cropBeingEdited = self.crop}
            print("Chosen crop is: \(self.chosenCrop?.cropName ?? "nil")")
//            self.isPresentedChooseCrop = false
            
            // If in editmode, dismiss sheet and return to edit harvest, or else navigate to add harvest sheet
            if(inEditMode) {
                
                self.presentationMode.wrappedValue.dismiss()

            } else {
                self.isPresentedAddHarvest = true

            }
        }
    }
}
