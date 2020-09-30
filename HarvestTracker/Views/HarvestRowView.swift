//
//  HarvestRowView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct HarvestRowView: View {
    
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
                
                // Row of tags
                HStack {
                    ForEach(harvest.tagArray ?? [Tag](), id: \.self) { tag in
                        TagView(tag: tag)
                            .disabled(true) // Disable buttons
                    }
                }
            }
            
            Spacer()
            
            Text(String(harvest.amountEntered))
                .font(.title)
            Text(String(harvest.unitEntered ?? "def"))
                .font(.caption)
            
        }
    }
}


