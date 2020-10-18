//
//  CropRowFilterView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/18/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct CropRowFilterView: View {
    
    var crop: Crop
    @Binding var chosenCrops: [Crop]
    @EnvironmentObject var settings: UserSettings
    
    
    var body: some View {
        
        // In a button so that anywhere in a row can be pressed
        Button(action: {
                // Add to chosen crops if not already there, or else remove
                if(chosenCrops.contains(crop)) {
                    
                    if let index = chosenCrops.firstIndex(of: self.crop) {
                        chosenCrops.remove(at: index)
                    }
                } else {
                    chosenCrops.append(crop)
                }},
               label: {
                
                HStack {
                    
                    if chosenCrops.contains(self.crop) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(settings.bgColor)
                    } else {
                        Image(systemName: "circle")
                    }
                    
                    Text(verbatim: crop.cropName ?? "")
                    Spacer()
                }
               }
        ) // end button
    }
}

