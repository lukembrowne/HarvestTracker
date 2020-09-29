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
    
    @State var tagName: String = ""
    static let defaultTagName = "default new tag"
    
    @State var chosenUnit = "oz"
    var units = ["oz", "lb", "g", "kg"]
    
    @State var chosenCostPerUnit = ""
    static let defaultCostPerUnit = "1"
    

    var body: some View {
            
            Form {
                
                // Add tag
                Section(header: Text("Tag")) {
                    
                    TextField("Tag Name", text: $tagName)
            
                }
                
                
                // Add crop button
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
            
    } // End body
    
    private func addTagAction() {
        
        print("Add tag button pressed")
        
        // Add tag to database
        Tag.addTag(tagName: tagName, tagColor: "default color", in: self.managedObjectContext)

    }
}

