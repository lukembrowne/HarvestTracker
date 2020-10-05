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
    
    @State var isPresentedAddTag = false
    @State var isPresentedEditTag = false
    @State var tagBeingEdited: Tag?
 
    
    var body: some View {
        
        
        VStack {
            
            Text("Tag list")
                .font(.title)
            
            // Testing
            Button(action: {print(self.tagBeingEdited)}, label: {Text("Print tag being edited")})
            
            Button(action: {self.isPresentedEditTag = true}, label: {Text("Open Edit sheet")})

            
            List {
                
                // Display tags in list
                ForEach(tags, id: \.self) { tag in
                    TagView(tag: tag,
                            tagBeingEdited: self.$tagBeingEdited,
                            isPresentedEditTag: self.$isPresentedEditTag,
                            inEditMode: true)

                }
                .onDelete(perform: deleteTag)
                
            } // list
            // When tag is tapped, open up editing mode
            .sheet(isPresented: self.$isPresentedEditTag) {

//                TestView(tagBeingEdited: self.$tagBeingEdited)
//                TestView2(tagBeingEdited: self.$tagBeingEdited.wrappedValue)
                AddTagView(tagBeingEdited: self.$tagBeingEdited,
//                           tag: self.tagBeingEdited,
                        inEditMode: true,
                        isPresentedAddTag: self.$isPresentedEditTag)
//
                 .environment(\.managedObjectContext, self.managedObjectContext)
                
     }// .sheet
            
            // Button to add new tag
            Button(action: { self.isPresentedAddTag.toggle()},
                   label: {
                    Image(systemName: "plus")
                    Text("Add New Tag")
                   })
                .foregroundColor(Color.white)
                .padding()
                .background(Color.green)
                .cornerRadius(5)
                .sheet(isPresented: $isPresentedAddTag) {
                    AddTagView(inEditMode: false,
                               isPresentedAddTag: $isPresentedAddTag)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
            
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
