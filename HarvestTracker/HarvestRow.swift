//
//  HarvestRow.swift
//  HarvestTracker
//
//  Created by Luke Browne on 8/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct HarvestRow: View {
    
    let harvest: Harvest
    
    static let releaseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        
        
        HStack {
            VStack(alignment: .leading) {
                harvest.crop.map(Text.init)
                    .font(.title)
                HStack {
                    harvest.harvestDate.map { Text(Self.releaseFormatter.string(from: $0)) }
                        .font(.caption)
                    Spacer()
                }
            }
            Spacer()
            Text(String(harvest.weight))
                .font(.title)
            Text(String(harvest.unit ?? "def"))
                .font(.caption)
            
        }
    }
}

