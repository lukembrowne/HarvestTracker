//
//  TagListView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct TagListView: View {
 
    // Fetch request for tags
    @FetchRequest(entity: Tag.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(
                        key: "tagName",
                        ascending: true,
                        selector: #selector(NSString.caseInsensitiveCompare(_:))) // To make case insensitive
                  ]) var tags: FetchedResults<Tag>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var settings: UserSettings
 
    
    var body: some View {
        
        
        VStack {
            
            Text("Tag list")
                .font(.title)
            
            List {
                
                // Display crops in list
                ForEach(tags, id: \.self) { tag in
                    Text(tag.tagName ?? "no name")
                }
                .onDelete(perform: deleteTag)
                
            } // list
            
            
            AddTagView()
                .environment(\.managedObjectContext, self.managedObjectContext)
            
            
        } // vstack
        .padding()
        
    } // view
    
    // Maybe there is a way to factor this out into Crop, but not sure how
    func deleteTag(at offsets: IndexSet) {
        offsets.forEach { index in
            let tag = self.tags[index]
            Tag.deleteTag(tag: tag, in: self.managedObjectContext)
        }
    }
}



struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
