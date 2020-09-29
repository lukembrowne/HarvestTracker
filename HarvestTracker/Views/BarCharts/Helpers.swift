//
//  File.swift
//
//
//  Created by András Samu on 2019. 07. 19..
//

import SwiftUI


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

// Small struct for deciding default unit

class DefaultUnit: ObservableObject {
    
    @Published var unitMass: UnitMass
    @Published var unitString: String {
        didSet {
            
            // Save to user defaults
            UserDefaults.standard.set(unitString, forKey: "DefaultUnit")
            
            // Update unitMass
            switch unitString {
            
            case "oz":
                print("Default unit set to oz")
                self.unitMass = UnitMass.ounces
            //                self.unitString = "oz"
            
            case "lb":
                print("Default unit set to lb")
                self.unitMass = UnitMass.pounds
            //                self.unitString = "lb"
            
            case "g":
                print("Default unit set to g")
                self.unitMass = UnitMass.grams
            //                self.unitString = "g"
            
            case "kg":
                print("Default unit set to kg")
                self.unitMass = UnitMass.kilograms
            //                self.unitString = "kg"
            
            default:
                print("No default unit chosen")
                self.unitMass = UnitMass.ounces
            //                self.unitString = "oz"
            
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
