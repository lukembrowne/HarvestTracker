//
//  TagViewCropName.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/16/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI


struct TagViewCrop: View {
    
    var crop: Crop
    @Binding var chosenCrops: [Crop]
    @Binding var displayedCrops: [Crop]
    
    
    // Init when tags are interactive for selecting in AddHarvestView
    init(crop: Crop, chosenCrops: Binding<[Crop]>, displayedCrops: Binding<[Crop]>) {
        self.crop = crop
        self._chosenCrops = chosenCrops
        self._displayedCrops = displayedCrops
    }
    
    
    var body: some View {
        

        if(self.displayedCrops.contains(self.crop)) {

            Text(self.crop.cropName ?? "...")

        } else {

            
            
            Button(action: {
                
                // If tag is already chosen, remove from chosen tags array
                if chosenCrops.contains(self.crop) {
                    
                    if let index = chosenCrops.firstIndex(of: self.crop) {
                        chosenCrops.remove(at: index)
                    }
                    
                } else {
                    // If tag not already in chosenTags, append to array
                    chosenCrops.append(self.crop)
                }
                
            }) {
                HStack {
                    // Tag name
                    Text(crop.cropName ?? "")
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    
                    // Add check mark if already part of chosen tags
                    if chosenCrops.contains(self.crop) {
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .foregroundColor(.white)
            .background(Color(UIColor(hexString: "000000",
                                      alpha: 0.9)))
            .cornerRadius(20)
            .buttonStyle(BorderlessButtonStyle()) // Bug fix so that entire row doesn't highlight
            .onAppear {
                // If button appears, add to displayed crop list
                self.displayedCrops.append(self.crop)
            }
        }
    }
    
}
