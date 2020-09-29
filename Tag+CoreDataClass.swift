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

@objc(Tag)
public class Tag: NSManagedObject {

    
    
    // Add Tag
    static func addTag(tagName: String,
                       tagColor: String,
                       in managedObjectContext: NSManagedObjectContext) {
        
        let newTag = Tag(context: managedObjectContext)
        
        newTag.tagName = tagName
        newTag.tagColor = tagColor

        // Save
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }

    
    
}
