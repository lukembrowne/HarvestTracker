//
//  AddTagView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct AddTagView: View {
    
    // Environment and bindings
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var inEditMode: Bool
    @Binding var isPresentedAddTag: Bool
    
    var tagBeingEdited: Tag?
    
    @State var tagName: String = ""
    static let defaultTagName = "default new tag"
    
    @State var chosenUnit = "oz"
    var units = ["oz", "lb", "g", "kg"]
    
    @State var chosenCostPerUnit = ""
    static let defaultCostPerUnit = "1"
    
    @State private var tagColor =
           Color(.sRGB, red: 0.964, green: 0.91, blue: 0.35)
    
    
    
    // When initializing in non-editing mode
    init(inEditMode: Bool,
         isPresentedAddTag: Binding<Bool>){
        self._isPresentedAddTag = isPresentedAddTag
        self._inEditMode = State(initialValue: inEditMode)
    }
    
    
    // When initializing in editing mode
    init(tagBeingEdited: Binding<Tag?>,
         inEditMode: Bool,
         isPresentedAddTag: Binding<Bool>) {
        
        let tagWrapped = tagBeingEdited.wrappedValue
        // Testing
        if let a = tagWrapped {
            print("Tag wrapped not nil!")
        } else {
            print("Tag wrapped is nil!")
        }
        self._tagName = State(initialValue: tagWrapped?.tagName ?? "...")
        self.tagBeingEdited = tagWrapped
        self._isPresentedAddTag = isPresentedAddTag
        self._inEditMode = State(initialValue: inEditMode)
        
    }
    
    
    
    
    

    var body: some View {
        
        VStack {
            
            // Title bar with cancel button
            ZStack{
                HStack{
                    Button(action: {
                        self.isPresentedAddTag.toggle()
                    }, label: {
                        Text("Cancel")
                        
                    })
                    Spacer()
                    
                }
                
                HStack{
                    if(inEditMode) {
                        Text("Edit tag")
                            .font(.headline)
                    } else {
                        Text("Add a new tag")
                            .font(.headline)
                    }
                }
            }.padding()
            
            // Testing
            Button(action: {print(self.tagBeingEdited)}, label: {Text("Print tag being edited")})
            
            Form {
                
                // Add tag
                Section(header: Text("Tag")) {
                    
                    TextField("Tag Name", text: $tagName)
            
                }
                
                
                // Pick color
                Section(header: Text("Choose a color")) {
                    
                    ColorPicker("Color", selection: $tagColor)

                }

                
                
                // Add tag button
                HStack {
                    Spacer()
                    Button(action: addTagAction, label: {
                        Image(systemName: "plus")
                        Text("Add Tag")
                    })
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(5)
                    Spacer()
                }
                
            }
            
        } // End Vstack
    } // End body
    
    private func addTagAction() {
        
        print("Add tag button pressed")
        
        // Add tag to database
        Tag.addTag(tagName: tagName,
                   tagColor: tagColor,
                   in: self.managedObjectContext)
        
        self.isPresentedAddTag.toggle() // close sheet

    }
}

