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
    
    static let releaseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                harvest.crop?.cropName.map(Text.init)
                    .font(.headline)
                
                harvest.harvestDate.map { Text(Self.releaseFormatter.string(from: $0)) }
                    .font(.caption)
                
                
                if let tagArray = harvest.tagArray  {
                    
                    
                    if tagArray.count > 0 {
                        // Row of tags
                        HStack {
                            ForEach(harvest.tagArray ?? [Tag](), id: \.self) { tag in
                                TagView(tag: tag)
                                    .disabled(true) // Disable buttons
                            }
                        }
                    } else {
                        Spacer() // Add spacer if there are no tags so that title of crop is always in the same spot
                    }
                }
            }
            
            Spacer()
            
            Text(String(harvest.amountEntered))
                .font(.title)
            Text(String(harvest.unitEntered ?? "def"))
                .font(.caption)
            
        }.frame(height: 75) // Set height of row - fixes bug that rows aren't properly formatted sometimes
    }
}


