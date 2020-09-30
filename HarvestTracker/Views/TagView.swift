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
    @State var isSelected = false
    @Binding var chosenTags: [Tag]
    
    
    init(tag: Tag ) {
        self.tag = tag
        self._chosenTags = Binding.constant([Tag]()) // Initialize empty binding that's never used if not
    }
    
    init(tag: Tag, chosenTags: Binding<[Tag]>) {
        self.tag = tag
        self._chosenTags = chosenTags
    }
    
    
    
    var body: some View {
        
        Button(action: {
            
            print(self.tag.tagName)
            isSelected.toggle() // Adds checkmark to box
            
           // Check to see if tag already exists in chosenTags, and if not, add it, if not, remove it
            chosenTags.append(self.tag)
            
            
        }) {
            HStack {
                // Tag name
                Text(tag.tagName ?? "")
                
                // Add check mark when selected
                if(isSelected) {
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
