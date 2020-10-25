//
//  File.swift
//
//
//  Created by András Samu on 2019. 07. 19..
//

import SwiftUI
import UIKit
import CoreData

import GameplayKit



public struct ChartForm {
    #if os(watchOS)
    public static let small = CGSize(width:120, height:90)
    public static let medium = CGSize(width:120, height:160)
    public static let large = CGSize(width:180, height:90)
    public static let extraLarge = CGSize(width:180, height:90)
    public static let detail = CGSize(width:180, height:160)
    #else
    public static let small = CGSize(width:180, height:120)
    public static let medium = CGSize(width:180, height:240)
    public static let large = CGSize(width:360, height:360)
    public static let extraLarge = CGSize(width:360, height:240)
    public static let detail = CGSize(width:180, height:120)
    #endif
}


public class ChartData: ObservableObject, Identifiable {
    @Published var points: [(String,Double)]
    var valuesGiven: Bool = false
    var ID = UUID()
    
    public init<N: BinaryFloatingPoint>(points:[N]) {
        self.points = points.map{("", Double($0))}
    }
    public init<N: BinaryInteger>(values:[(String,N)]){
        self.points = values.map{($0.0, Double($0.1))}
        self.valuesGiven = true
    }
    public init<N: BinaryFloatingPoint>(values:[(String,N)]){
        self.points = values.map{($0.0, Double($0.1))}
        self.valuesGiven = true
    }
    public init<N: BinaryInteger>(numberValues:[(N,N)]){
        self.points = numberValues.map{(String($0.0), Double($0.1))}
        self.valuesGiven = true
    }
    public init<N: BinaryFloatingPoint & LosslessStringConvertible>(numberValues:[(N,N)]){
        self.points = numberValues.map{(String($0.0), Double($0.1))}
        self.valuesGiven = true
    }
    
    public func onlyPoints() -> [Double] {
        return self.points.map{ $0.1 }
    }
}


public class TestData{
    static public var data:ChartData = ChartData(points: [37,72,51,22,39,47,66,85,50])
    static public var values:ChartData = ChartData(values: [("2017 Q3",220),
                                                            ("2017 Q4",1550),
                                                            ("2018 Q1",8180),
                                                            ("2018 Q2",18440),
                                                            ("2018 Q3",55840),
                                                            ("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)])
    
}

// Extension for rounding doubles
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// Converting UIColor to and from hex codes
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}



class Testing {
    
    
    // Create tags
    func createTags(in managedObjectContext: NSManagedObjectContext) {
        
        // Add tag to database
        Tag.addTag(tagName: "Organic",
                   tagColor: Color(UIColor(hexString: "#86B953")),
                   in: managedObjectContext)
        // Add tag to database
        Tag.addTag(tagName: "Container",
                   tagColor: Color(UIColor(hexString: "#D03A20")),
                   in: managedObjectContext)
        // Add tag to database
        Tag.addTag(tagName: "Backyard",
                   tagColor: Color(UIColor(hexString: "#4585F6")),
                   in: managedObjectContext)
        
    }
    
    
    // Create harvests
    func createHarvests(in managedObjectContext: NSManagedObjectContext) {
        
        var crops = [Crop]()
        var tags = [Tag]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let arc4 = GKARC4RandomSource()
        let amountRng = GKGaussianDistribution(randomSource: arc4, mean: 10, deviation: 3)
        let dayRng = GKGaussianDistribution(lowestValue: 1, highestValue: 27)
        let monthRng = GKGaussianDistribution(randomSource: arc4, mean: 6, deviation: 1.5)
                
        let nSims = 100
        print("Generating data for \(nSims) simulated harvests")
        
        for _ in 1...nSims {
            
            var tagsToApply = [Tag]()
            
            let nTags = Int.random(in: 1..<3)
            
            do {
                
                let cropsFetch = NSFetchRequest<Crop>(entityName: "Crop")
                //                cropsFetch.predicate = NSPredicate(format: "cropName == %@", cropName)
                
                try crops = managedObjectContext.fetch(cropsFetch)
                try tags = managedObjectContext.fetch(NSFetchRequest<Tag>(entityName: "Tag"))
                
                tags = tags.shuffled()
                
                for n in 1...nTags {
                    tagsToApply.append(tags[n])
                }
                
            } catch {
                print("Fetching failed")
                
                
            }
            
            // Simulate date
            let simDate =  "2020-" + String(monthRng.nextInt()) + "-" + String(dayRng.nextInt())
            
            
            Harvest.addHarvest(crop: crops.randomElement(),
                               amountEntered: String(amountRng.nextInt()),
                               harvestDate: dateFormatter.date(from: simDate) ?? Date(),
                               unit: "oz",
                               chosenTags: tagsToApply,
                               isPresented: Binding.constant(false),
                               in: managedObjectContext)
            
        } // nSim loop
        
    } // end create Harvests
    
    
    // Create harvests
    func deleteAllData(in managedObjectContext: NSManagedObjectContext) {
        
        var tags = [Tag]()
        var harvests = [Harvest]()
        
        do {
            
            print("Deleting all harvests and tags...")
            
            try tags = managedObjectContext.fetch(NSFetchRequest<Tag>(entityName: "Tag"))
            try harvests = managedObjectContext.fetch(NSFetchRequest<Harvest>(entityName: "Harvest"))
            
            
            for tag in tags {
                
                Tag.deleteTag(tag: tag, in: managedObjectContext)
            }
            
            for harvest in harvests {
                Harvest.deleteHarvest(harvest: harvest, in: managedObjectContext)
            }
            
        } catch {
            print("Fetching failed")
        }
        
    } // end delete all data
    
}


