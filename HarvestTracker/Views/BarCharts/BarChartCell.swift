//
//  ChartCell.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.


import SwiftUI

public struct BarChartCell : View {
    
    @EnvironmentObject var settings: UserSettings
    
    var value: Double
    var rawValue: Double
    var label: String
    var index: Int = 0
    var width: Float
    var numberOfDataPoints: Int
    var cellWidth: Double {
        return Double(width)/(Double(numberOfDataPoints) * 1.5)
    }
    var rawValueDisplay: Double {
        // Update unitMass to convert to proper unit
        switch chosenUnit {
        
        case "oz":
            //                print("Default unit set to oz")
            let unitMass = UnitMass.ounces
            return Measurement(value: rawValue, unit: UnitMass.grams).converted(to: unitMass).value
            
        case "lb":
            //                print("Default unit set to lb")
            let unitMass = UnitMass.pounds
            return Measurement(value: rawValue, unit: UnitMass.grams).converted(to: unitMass).value
            
        case "g":
            //                print("Default unit set to g")
            let unitMass = UnitMass.grams
            return Measurement(value: rawValue, unit: UnitMass.grams).converted(to: unitMass).value
            
        case "kg":
            //                print("Default unit set to kg")
            let unitMass = UnitMass.kilograms
            return Measurement(value: rawValue, unit: UnitMass.grams).converted(to: unitMass).value
            
        default:
            //                print("No default unit chosen")
            let unitMass = UnitMass.ounces
            return Measurement(value: rawValue, unit: UnitMass.grams).converted(to: unitMass).value
        }
    }
    
    @Binding var touchLocation: CGFloat
    @Binding var showValue: Bool
    @Binding var opacity: Double
    @Binding var chosenUnit: String

    
    public var body: some View {
        
        VStack {
            
            ZStack {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(gradient:
                                                Gradient(colors: [settings.bgColor.opacity(0.40), settings.bgColor]),
                                             startPoint: .bottom, endPoint: .top))
                }
                .opacity(opacity)
                .frame(width: CGFloat(self.cellWidth))
                .scaleEffect(CGSize(width: 1, height: self.value), anchor: .bottom)
                .animation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.04 : 0))
                
                
                if showValue {
                    VStack{
                        Text("\(rawValueDisplay, specifier: "%.1f")")
                            .font(.caption2)
                            .fixedSize()
                            .frame(width: CGFloat(self.cellWidth))
                            .offset(x: 0, y: -15)
                            .opacity(opacity)
                        Spacer()
                            .zIndex(999)
                    }
                }
            }
            
            
            
            Text(label)
                .font(.caption2)
                .fixedSize()
                .frame(width: CGFloat(self.cellWidth), height: CGFloat(5))
                .rotationEffect(.degrees(-45))
                .fixedSize(horizontal: true, vertical: true)
                .padding([.bottom, .top], 5)
                .opacity(opacity)
        }
    }
    
}

//#if DEBUG
//struct ChartCell_Previews : PreviewProvider {
//    static var previews: some View {
//        BarChartCell(value: Double(0.75), label: "Test", width: 320, numberOfDataPoints: 12, touchLocation: .constant(-1))
//    }
//}
//#endif
