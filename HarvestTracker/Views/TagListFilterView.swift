//
//  TagListFilterView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/18/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct TagListFilterView: View {
    
    
    // Fetch request for tags
    @FetchRequest(entity: Tag.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(
                        key: "tagName",
                        ascending: true,
                        selector: #selector(NSString.caseInsensitiveCompare(_:))) // To make case insensitive
                  ]) var tags: FetchedResults<Tag>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var chosenTags: [Tag]
        
    
    var body: some View {
      
        // If no crops added yet
        if(tags.count == 0) {
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("No tags added yet!")
                    Spacer()
                }
                Spacer()
            }
    
            
        } else {
        
        List {
            
            // Display crops in list
            ForEach(tags, id: \.self) { tag in

                TagRowFilterView(tag: tag,
                                  chosenTags: $chosenTags)
                
            }
            
        } // list

        } // End if statement
    }
}
