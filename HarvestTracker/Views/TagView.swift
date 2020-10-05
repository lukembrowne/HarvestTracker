//
//  TagView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct TagView: View {
    
    var tag: Tag
    @Binding var chosenTags: [Tag]
    @Binding var tagBeingEdited: Tag?
    @Binding var isPresentedEditTag: Bool
    var inEditMode = false
    
    // Init when tags are just displayed, like in HarvestListView
    init(tag: Tag) {
        self.tag = tag
        self._chosenTags = Binding.constant([Tag]()) // Initialize empty binding that's never used if not
        self._tagBeingEdited = Binding.constant(nil)
        self._isPresentedEditTag = Binding.constant(false)
    }
    
    // Init when tags are interactive for selecting in AddHarvestView
    init(tag: Tag, chosenTags: Binding<[Tag]>) {
        self.tag = tag
        self._chosenTags = chosenTags
        self._tagBeingEdited = Binding.constant(nil)
        self._isPresentedEditTag = Binding.constant(false)
    }
    
    // Initializing in edit mode
    init(tag: Tag,
         tagBeingEdited: Binding<Tag?>,
         isPresentedEditTag: Binding<Bool>,
         inEditMode: Bool) {
        
        self.tag = tag
        self._tagBeingEdited = tagBeingEdited
        self._isPresentedEditTag = isPresentedEditTag
        self.inEditMode = inEditMode
        self._chosenTags = Binding.constant([Tag]()) // Initialize empty binding that's never used if not
 
    }
    
    
    
    var body: some View {
        
        Button(action: {
            
            // If in edit mode, set the pressed tag as the being edited and open up edit tag sheet
            if(inEditMode){
                self.tagBeingEdited = self.tag
                print("Chosen tag is: \(String(describing: self.tagBeingEdited))")
            }
            
            // If tag is already chosen, remove from chosen tags array
            if chosenTags.contains(self.tag) {
                
                if let index = chosenTags.firstIndex(of: self.tag) {
                    chosenTags.remove(at: index)
                }
                
            } else {
                // If tag not already in chosenTags, append to array
                chosenTags.append(self.tag)
            }
                     

            if(inEditMode) {
                self.isPresentedEditTag = true
            }

        }) {
            HStack {
                // Tag name
                Text(tag.tagName ?? "")
                
                // Add check mark if already part of chosen tags
                if chosenTags.contains(self.tag) {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
        }
        .padding(5)
        .foregroundColor(.white)
        .background(Color(UIColor(hexString: tag.tagColorHex ?? "000000",
                                  alpha: 0.9)))
        .cornerRadius(20)
        .buttonStyle(BorderlessButtonStyle()) // Bug fix so that entire row doesn't highlight
    }
}

//struct TagView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagView(tagName: "Test",
//                tagColorHex: "000000")
//    }
//}
