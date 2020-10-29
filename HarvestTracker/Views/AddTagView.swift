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
    
    @Binding var tagBeingEdited: Tag?
    
    @State var tagName: String = ""
    static let defaultTagName = "default new tag"
    
    @State var chosenUnit = "oz"
    var units = ["oz", "lb", "g", "kg"]
    
    @State var chosenCostPerUnit = ""
    static let defaultCostPerUnit = "1"
    
    //    @State private var tagColor =
    //        Color(.sRGB, red: 0.964, green: 0.91, blue: 0.35)
    
    @State private var tagColor =
        Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5)
    
    
    
    
    // When initializing in non-editing mode
    init(inEditMode: Bool,
         isPresentedAddTag: Binding<Bool>){
        self._isPresentedAddTag = isPresentedAddTag
        self._inEditMode = State(initialValue: inEditMode)
        self._tagBeingEdited = Binding.constant(nil)
    }
    
    
    // When initializing in editing mode
    init(tagBeingEdited: Binding<Tag?>,
         inEditMode: Bool,
         isPresentedAddTag: Binding<Bool>) {
        
        self._tagBeingEdited = tagBeingEdited
        self._isPresentedAddTag = isPresentedAddTag
        self._inEditMode = State(initialValue: inEditMode)
        
    }
    
    
    var body: some View {
        
        VStack {
            
            // Title bar with cancel button
            ZStack{
                
                // Cancel button
                HStack{
                    Button(action: {
                        self.isPresentedAddTag.toggle()
                    }, label: {
                        Text("Cancel")
                        
                    })
                    Spacer()
                    
                }
                
                // Title
                HStack{
                    if(inEditMode) {
                        Text("Edit tag")
                            .font(.headline)
                    } else {
                        Text("Add tag")
                            .font(.headline)
                    }
                }
                
                // Save button
                HStack{
                    Spacer()
                    Button(action: {
                        
                        if(inEditMode) {
                            self.updateTagAction()
                        } else {
                            self.addTagAction()
                        }
                        
                    },
                    label: {
                        Image(systemName: "checkmark.circle")
                        Text("Save")
                    })
                }
                
                
                
            }.padding()
            
            
            Form {
                
                // Add tag
                Section(header: Text("Tag")) {
                    
                    TextField("Tag Name", text: $tagName)
                        .introspectTextField { textField in
                            textField.becomeFirstResponder()
                        }
                    
                }
                
                
                
                // Pick color
                Section(header: Text("Choose a color")) {
                    
                    ColorPicker("Color", selection: $tagColor)
                    
                }
                
                
                
                // Add tag button
//                HStack {
//                    Spacer()
//                    Button(action: {
//
//                        if(inEditMode) {
//                            self.updateTagAction()
//                        } else {
//                            self.addTagAction()
//                        }
//
//                    }, label: {
//
//                        if(inEditMode){
//                            Image(systemName: "checkmark.circle")
//                            Text("Save edits")
//                        } else {
//                            Image(systemName: "plus")
//                            Text("Add Tag")
//                        }
//                        
//                    })
//                    .foregroundColor(Color.white)
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(5)
//                    Spacer()
//                }
                
            }
            
        } // End Vstack
        // Need to set states on appearance of view bc setting these states in initializer was not working - work around for potential bug
        .onAppear {
            if(inEditMode) {
                self.tagName = tagBeingEdited?.tagName ?? ""
                self.tagColor = Color(UIColor(hexString: tagBeingEdited?.tagColorHex ?? "000000"))
            }
        }
    } // End body
    
    private func addTagAction() {
                
        // Add tag to database
        Tag.addTag(tagName: tagName,
                   tagColor: tagColor,
                   in: self.managedObjectContext)
        
        self.isPresentedAddTag.toggle() // close sheet
        
    }
    
    private func updateTagAction() {
                
        // Add tag to database
        Tag.updateTag(tag: tagBeingEdited!,
                      tagName: tagName,
                      tagColor: tagColor,
                      in: self.managedObjectContext)
        
        self.isPresentedAddTag.toggle() // close sheet
        
    }
}

