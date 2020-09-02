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
    @Binding var chosenCrop: String
    
    // Set environment variable so that the list closes when a crop is selected
    @Environment(\.presentationMode) var presentation

    
    var body: some View {
        
        HStack {
            Image(systemName: "sun.max")
            Text(verbatim: crop.cropName ?? "")
            Spacer()
        }.onTapGesture {
            self.chosenCrop = self.crop.cropName ?? ""
            print(self.chosenCrop)
            self.presentation.wrappedValue.dismiss()
        }
    }
}
