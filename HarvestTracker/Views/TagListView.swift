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
        
        ZStack {
            
            settings.bgColor.ignoresSafeArea() // to color in notch
            
            VStack {
                
                VStack {
                    // Title
                    HStack {
                        Spacer()
                        Text("Tag list")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    
                    // New tag button
                    HStack {
                        Spacer()
                        Button(action: { self.isPresentedAddTag.toggle()},
                               label: {
                                Image(systemName: "plus")
                                    .foregroundColor(Color.white)
                                Text("New Tag")
                                    .foregroundColor(Color.white)
                               })
                            .padding(settings.cardPadding)
                            .sheet(isPresented: $isPresentedAddTag) {
                                AddTagView(inEditMode: false,
                                           isPresentedAddTag: $isPresentedAddTag)
                                    .environment(\.managedObjectContext, self.managedObjectContext)
                            }
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 20
                                )
                                .foregroundColor(settings.lightAccentColor)
                                .shadow(radius: settings.buttonShadowRadius)
                            )
                        Spacer()
                    }
                }
                
                // If no tags added yet
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
                    .padding(.top, 20)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .foregroundColor(Color.white)
                        .shadow(radius: settings.cardShadowRadius)
                    )
                    
                } else {
                    
                    // Start tag list
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
                        
                        AddTagView(tagBeingEdited: self.$tagBeingEdited,
                                   inEditMode: true,
                                   isPresentedAddTag: self.$isPresentedEditTag)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                        
                    } // .sheet
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .foregroundColor(Color.white)
                        .shadow(radius: settings.cardShadowRadius)
                    )

                } // end if statement
            } // vstack
            .navigationBarTitle("", displayMode: .inline) // Avoid large white space if viewing from Settings
            .padding(settings.cardPadding)
            .padding(.bottom, settings.cardPadding - 2)
            
        } // Zstack
        
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
