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
    
    var maxValue: Double {
        guard let max = data.max() else {
            return 1
        }
        return max != 0 ? max : 1
    }
    
    // For dragging gesture
    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    @State private var currentValue: Double = 0
    
    public var body: some View {
        
        GeometryReader { geometry in
            
            HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.data.count * 3)){
                
                HStack {
                    
                    // If no harvest data found, display text in center of view
                    if data.max() == 0 {
                        
                        HStack{
                            Spacer()
                            VStack {
                                Spacer()
                                Text("No harvest data found!")
                                Spacer()
                            }
                            Spacer()
                        }
                        
                    } else {
                        
                        // Y axis labels
                        HStack {
                            
                            VStack {
                                // Y axis label at the top
                                Text("\(Int(Measurement(value: maxValue, unit: UnitMass.grams).converted(to: settings.unitMass).value)) \(settings.unitString)")
                                    .font(.caption2)
                                    .offset(x: 0, y: -8)
                                
                                Spacer()
                                
                                Text("Amount")
                                    .rotationEffect(.degrees(-90))
                                    .font(.caption2)
                                    .offset(x: -25, y: -4)
                                
                                Spacer()
                                
                                
                                
                                // Y axis lab at bottom
                                Text("0 \(settings.unitString)")
                                    .font(.caption2)
                            }
                        }
                        
                        ZStack {
                            
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
                                
                                ZStack {
                                    
                                    HStack {
                                        ForEach(0..<self.data.count, id: \.self) { i in
                                            
                                            BarChartCell(value: self.normalizedValue(index: i),
                                                         label: labels[i],
                                                         index: i,
//                                                         width: Float(geometry.frame(in: .local).width - 55),// Original width offset was 22, changed to 55
                                                         width: Float(geometry.size.width),
                                                         numberOfDataPoints: self.data.count,
                                                         touchLocation: self.$touchLocation)
                                                
                                                .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.data.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.data.count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                                                .animation(.spring())
                                        } // end foreach
                                    } // end hstack
                                    .gesture(DragGesture()
                                                .onChanged({ value in
                                                    self.touchLocation = value.location.x/geometry.size.width
                                                    self.showValue = true
                                                    self.currentValue = self.getCurrentValue(width: geometry.size.width) ?? 0
                                                    print("touch location is: \(self.touchLocation)")
                                                    print("currentValue is: \(self.currentValue)")
 
//                                                    if(self.data.valuesGiven && self.formSize == ChartForm.medium) {
//                                                        self.showLabelValue = true
//                                                    }
                                                })
                                                .onEnded({ value in
                                                    self.showValue = false
                                                    self.showLabelValue = false
                                                    self.touchLocation = -1
                                                })
                                    )
                                    .gesture(TapGesture()
                                    )
                                    
                                    

                                
                                // Year label
                                VStack {
                                    Spacer()
                                    Text("2020")
                                        .font(.caption)
                                        .offset(x: 0, y: 20)
                                }// vstack
                                }
                            } // zstack
                        } // zstack
                        
                    } // if else
                }
            }
            .padding([.top, .leading, .trailing, .bottom], 10)
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
}

