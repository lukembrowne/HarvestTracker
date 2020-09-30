//
//  Tag+CoreDataClass.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Tag)
public class Tag: NSManagedObject {

    
    
    // Add Tag
    static func addTag(tagName: String,
                       tagColor: Color,
                       in managedObjectContext: NSManagedObjectContext) {
        
        let newTag = Tag(context: managedObjectContext)
        
        newTag.tagName = tagName
        newTag.tagColorHex = UIColor(tagColor).toHexString() // Convert from SwiftUI color to hex

        // Save
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    // Delete Harvest
        static func deleteTag(tag: Tag, in managedObjectContext: NSManagedObjectContext ) {
            
            // Delete
            managedObjectContext.delete(tag)
            
            // Save
            do {
                try managedObjectContext.save()
            } catch {
                print("Error saving managed object context: \(error)")
            }
            
        }

    
    
}
