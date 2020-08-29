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
      VStack(alignment: .leading) {
        // 1
        harvest.crop.map(Text.init)
          .font(.title)
        HStack {
          // 2
            harvest.weight.map(Text.init)
            .font(.caption)
          Spacer()
          // 3
            harvest.harvestDate.map { Text(Self.releaseFormatter.string(from: $0)) }
            .font(.caption)
        }
      }
    }
}

