//
//  CropListFilterView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/18/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct CropListFilterView: View {
    
    // Fetch request for crops
    @FetchRequest(entity: Crop.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(
                        key: "cropName",
                        ascending: true,
                        selector: #selector(NSString.caseInsensitiveCompare(_:))) // To make case insensitive
                  ]) var crops: FetchedResults<Crop>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var chosenCrops: [Crop]
    
    
    
    var body: some View {
        
        // If no crops added yet
        if(crops.count == 0) {
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("No crops added yet!")
                    Spacer()
                }
                Spacer()
            }
    
            
        } else {
        
        List {
            
            // Display crops in list
            ForEach(crops, id: \.self) { crop in

                CropRowFilterView(crop: crop,
                                  chosenCrops: $chosenCrops)
                
            }
            
        } // list
        } // End if statement
    }
}


