//
//  TagRowFilterView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/18/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct TagRowFilterView: View {
    
    var tag: Tag
    @Binding var chosenTags: [Tag]
    
    var body: some View {
        
        // In a button so that anywhere in a row can be pressed
        Button(action: {
                // Add to chosen tags if not already there, or else remove
                if(chosenTags.contains(tag)) {
        
                    if let index = chosenTags.firstIndex(of: self.tag) {
                        chosenTags.remove(at: index)
                    }
                } else {
                    chosenTags.append(tag)
                }},
               label: {
        
                HStack {
        
                    if chosenTags.contains(self.tag) {
                        Image(systemName: "checkmark.circle.fill")
                    } else {
                        Image(systemName: "circle")
                    }
        
                    Text(verbatim: tag.tagName ?? "")
                    Spacer()
                }
               }
        ) // end button

    }
}

