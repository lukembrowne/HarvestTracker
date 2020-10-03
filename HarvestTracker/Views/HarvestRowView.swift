//
//  HarvestRowView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct HarvestRowView: View {
    
    //    @ObservedObject let harvest: Harvest // Causes exclusive access bug
    let harvest: Harvest
    @Binding var chosenCrop: Crop?
    @Binding var chosenHarvest: Harvest?
    @Binding var isPresentedAddHarvest: Bool
    
    static let releaseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        
        
        VStack {
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    harvest.crop?.cropName.map(Text.init)
                        .font(.headline)
                    
                    harvest.harvestDate.map { Text(Self.releaseFormatter.string(from: $0)) }
                        .font(.caption)
                }
                Spacer()
                
                Text(String(harvest.amountEntered))
                    .font(.title)
                Text(String(harvest.unitEntered ?? "def"))
                    .font(.caption)
                
            }
            
            
            if let tagArray = harvest.tagArray  {
                
                if tagArray.count > 0 {
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.flexible())]) {
                            ForEach(harvest.tagArray ?? [Tag](), id: \.self) { tag in
                                TagView(tag: tag)
                                    .disabled(true)
                            }
                        }
                    }
                }
            }
        }
        .onTapGesture {
            self.chosenHarvest = self.harvest
            self.chosenCrop = self.harvest.crop
            print("Chosen crop is: \(self.chosenCrop?.cropName ?? "nil")")
//            self.isPresentedChooseCrop = false
            self.isPresentedAddHarvest = true
        }
        
        
        // .frame(height: 75) // Set height of row - fixes bug that rows aren't properly formatted sometimes
    }
}


