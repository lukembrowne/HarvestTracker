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
                    .font(.title)
                HStack {
                    harvest.harvestDate.map { Text(Self.releaseFormatter.string(from: $0)) }
                        .font(.caption)
                    Spacer()
                }
            }
            Spacer()
            Text(String(harvest.amountEntered))
                .font(.title)
            Text(String(harvest.unitEntered ?? "def"))
                .font(.caption)
            
            Text(String(harvest.amountStandardized))
                .font(.title)
            Text(String("g"))
                .font(.caption)
            Text(String(harvest.amountStandardized))
                          .font(.title)
                      Text(String("g"))
                          .font(.caption)
            
        }
    }
}

