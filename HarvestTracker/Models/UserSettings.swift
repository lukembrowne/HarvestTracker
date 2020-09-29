//
//  UserSettings.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import Foundation



class UserSettings: ObservableObject {
    
    @Published var unitMass: UnitMass
    @Published var unitString: String {
        didSet {
            
            // Save to user defaults
            UserDefaults.standard.set(unitString, forKey: "DefaultUnit")
            
            // Update unitMass
            switch unitString {
            
            case "oz":
//                print("Default unit set to oz")
                self.unitMass = UnitMass.ounces
            
            case "lb":
//                print("Default unit set to lb")
                self.unitMass = UnitMass.pounds
            
            case "g":
//                print("Default unit set to g")
                self.unitMass = UnitMass.grams
            
            case "kg":
//                print("Default unit set to kg")
                self.unitMass = UnitMass.kilograms
            
            default:
//                print("No default unit chosen")
                self.unitMass = UnitMass.ounces
            
            }
            
        }
    }
    
    init() {
        
        switch UserDefaults.standard.string(forKey: "DefaultUnit") {
        
        case "oz":
            print("Default unit oz")
            self.unitMass = UnitMass.ounces
            self.unitString = "oz"
            
        case "lb":
            print("Default unit lb")
            self.unitMass = UnitMass.pounds
            self.unitString = "lb"
            
        case "g":
            print("Default unit g")
            self.unitMass = UnitMass.grams
            self.unitString = "g"
            
        case "kg":
            print("Default unit kg")
            self.unitMass = UnitMass.kilograms
            self.unitString = "kg"
            
        default:
            print("No default unit chosen")
            self.unitMass = UnitMass.ounces
            self.unitString = "oz"
            
        }
    }
    
}
