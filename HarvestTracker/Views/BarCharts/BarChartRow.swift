//
//  ChartRow.swift
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

public struct BarChartRow : View {
    
    @EnvironmentObject var settings: UserSettings
    
    var data: [Double]
    var labels: [String]
    @State var opacity = [Double](repeating: 1.0, count: 12)
    
    var maxValue: Double {
        guard let max = data.max() else {
            return 1
        }
        return max != 0 ? max : 1
    }
    
    var maxValueDisplay: Double {
        guard let max = data.max() else {
            return 1
        }
        
        // Update unitMass to convert to proper unit
        switch chosenUnit {
        
        case "oz":
            //                print("Default unit set to oz")
            let unitMass = UnitMass.ounces
            return Measurement(value: max, unit: UnitMass.grams).converted(to: unitMass).value
            
        case "lb":
            //                print("Default unit set to lb")
            let unitMass = UnitMass.pounds
            return Measurement(value: max, unit: UnitMass.grams).converted(to: unitMass).value
            
        case "g":
            //                print("Default unit set to g")
            let unitMass = UnitMass.grams
            return Measurement(value: max, unit: UnitMass.grams).converted(to: unitMass).value
            
        case "kg":
            //                print("Default unit set to kg")
            let unitMass = UnitMass.kilograms
            return Measurement(value: max, unit: UnitMass.grams).converted(to: unitMass).value
            
        default:
            //                print("No default unit chosen")
            let unitMass = UnitMass.ounces
            return Measurement(value: max, unit: UnitMass.grams).converted(to: unitMass).value
        }
        
    }
    
    // For dragging gesture
    @State private var touchLocation: CGFloat = -1.0
    //    @State private var showValue: Bool = false
    @State private var showValue = [Bool](repeating: false, count: 12)
    @State private var showLabelValue: Bool = false
    @State private var currentValue: Double = 0
    @Binding var year: Int
    @Binding var chosenUnit: String
    
    public var body: some View {
        
        GeometryReader { geometry in
            
            // Vstack with main graph on top and year label on bottom
            VStack {
                
                HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.data.count * 3)){
                    
                    HStack {
                        
                        // Y axis labels
                        HStack {
                            
                            VStack {
                                // Y axis label at the top
                                //                                Text("\(Int(Measurement(value: maxValue, unit: UnitMass.grams).converted(to: settings.unitMass).value)) \(settings.unitString)")
                                Text("\(maxValueDisplay, specifier: "%.1f") \(chosenUnit)")
                                    .font(.caption2)
                                    .offset(x: 0, y: -8)
                                
                                Spacer()
                                
                                Text("Amount")
                                    .rotationEffect(.degrees(-90))
                                    .font(.caption2)
                                    .offset(x: -25, y: -4)
                                
                                Spacer()
                                
                                // Y axis lab at bottom
                                Text("0 \(chosenUnit)")
                                    .font(.caption2)
                            }
                        }
                        
                        ZStack {
                            
                            // If no harvest data found, display text in center of view
                            if(data.max() == 0 ) {
                                HStack{
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        Text("No harvest data yet!")
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            
                            
                            // Add dashed line at the top
                            Path{ path in
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLine(to:
                                                CGPoint(x: geometry.frame(in: .local).width - 60,
                                                        y: 0))
                            }
                            .stroke(style: StrokeStyle( lineWidth: 2, dash: [5]))
                            .foregroundColor(Color.black.opacity(0.15))
                            
                            // Bars
                            GeometryReader { geometry in
                                
                                HStack {
                                    ForEach(0..<self.data.count, id: \.self) { i in
                                        
                                        BarChartCell(value: self.normalizedValue(index: i),
                                                     rawValue: data[i],
                                                     label: labels[i],
                                                     index: i,
                                                     width: Float(geometry.size.width),
                                                     numberOfDataPoints: self.data.count,
                                                     touchLocation: self.$touchLocation,
                                                     showValue: self.$showValue[i],
                                                     opacity: self.$opacity[i],
                                                     chosenUnit: $chosenUnit)
                                        //                                                .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.data.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.data.count) ? CGSize(width: 1.05, height: 1.05) : CGSize(width: 1, height: 1), anchor: .bottom)
                                        //                                                .animation(.spring())
                                    } // end foreach
                                    
                                    
                                } // end hstack
                                .contentShape(Rectangle())
                                
                                .gesture(DragGesture(minimumDistance: 0)
                                            .onChanged({ value in
                                                self.touchLocation = value.location.x/geometry.size.width
                                                let currentIndex = self.getCurrentIndex(width: geometry.size.width) ?? 0
                                                self.currentValue = self.data[currentIndex]
                                                self.showValue = [Bool](repeating: false, count: 12)
                                                self.showValue[currentIndex] = true
                                                self.opacity = [Double](repeating: 0.35, count: 12)
                                                self.opacity[currentIndex] = 1.0
                                                
                                            })
                                            .onEnded({ value in
                                                let currentIndex = self.getCurrentIndex(width: geometry.size.width) ?? 0
                                                self.showValue[currentIndex] = false
                                                self.showLabelValue = false
                                                self.touchLocation = -1
                                                self.opacity = [Double](repeating: 1.0, count: 12)
                                            })
                                )
                                
                            } // zstack
                            
                            
                        } // zstack
                    }
                }
                .padding([.top, .leading, .trailing, .bottom], 10)
                
                // Year label
                HStack {
                    Button(action: {
                        print("subtract")
                        self.year = self.year - 1
                    }, label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(settings.bgColor)
                            
                        })
                    
                    
                    Text(String(year))
                        .font(.caption)
                    
                    Button(action: {
                        print("add")
                        self.year = self.year + 1
                        
                    }, label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(settings.bgColor)
                        
                    })
                    
                }
                
                
            }
            
            
            
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        return Double(self.data[index])/Double(self.maxValue)
    }
    
    
    func getCurrentValue(width: CGFloat) -> Double? {
        
        guard self.data.count > 0 else { return nil}
        //        let index = max(0,min(self.data.points.count-1,Int(floor((self.touchLocation*self.formSize.width)/(self.formSize.width/CGFloat(self.data.points.count))))))
        
        //        let index = max(0,min(self.data.count-1,Int(floor((self.touchLocation*width)/(width/CGFloat(self.data.count))))))
        
        let intfloor = Int(floor(  (self.touchLocation*width) / (width/CGFloat(self.data.count))    ))
        let min2 = min(self.data.count-1, intfloor) // selects right most if needed
        let index = max(0, min2) // selects left most if needed
        print("current index is: \(index)")
        
        
        return self.data[index]
    }
    
    func getCurrentIndex(width: CGFloat) -> Int? {
        
        guard self.data.count > 0 else { return nil}
        
        let index = max(0,min(self.data.count-1,Int(floor((self.touchLocation*width)/(width/CGFloat(self.data.count))))))
        
        return index
    }
    
    
}

