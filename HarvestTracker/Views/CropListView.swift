//
//  CropListView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/2/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct CropListView: View {
    
    
    // Fetch request for crops
    @FetchRequest(entity: Crop.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Crop.cropName, ascending: true)
                        ]) var crops: FetchedResults<Crop>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var chosenCrop: Crop?
    
    @State var isPresentedAddCrop = false



    var body: some View {
        
        VStack {
            Button(action: { self.isPresentedAddCrop.toggle() },
                   label: {
                              Image(systemName: "plus")
                              Text("Add New Crop")
                                  })
                                  .foregroundColor(Color.white)
                                  .padding()
                                  .background(Color.green)
                                  .cornerRadius(5)
            .sheet(isPresented: $isPresentedAddCrop) {
                    AddCropView()
                .environment(\.managedObjectContext, self.managedObjectContext)
            }
            
                
            List(crops) { crop in
             CropRowView(crop: crop,
                         chosenCrop: self.$chosenCrop)
             }
        }
        

    }
}

